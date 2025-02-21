{{ config(
    materialized='table'
) }}

WITH quarterly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(QUARTER FROM pickup_datetime) AS quarter,
        CASE
            WHEN service_type = 'Green' THEN 'Green'
            WHEN service_type = 'Yellow' THEN 'Yellow'
            ELSE 'Unknown'
        END AS taxi_type,
        SUM(total_amount) AS quarterly_revenue
    FROM {{ ref('fact_trips') }}
    GROUP BY
        year,
        quarter,
        taxi_type
),
yoy_growth AS (
    SELECT
        qr.year,
        qr.quarter,
        qr.taxi_type,
        qr.quarterly_revenue,
        LAG(qr.quarterly_revenue) OVER (
            PARTITION BY qr.taxi_type, qr.quarter
            ORDER BY qr.year
        ) AS previous_year_revenue,
        CASE
            WHEN LAG(qr.quarterly_revenue) OVER (
                PARTITION BY qr.taxi_type, qr.quarter
                ORDER BY qr.year
            ) IS NOT NULL
            THEN ROUND(
                100.0 * (qr.quarterly_revenue - LAG(qr.quarterly_revenue) OVER (
                    PARTITION BY qr.taxi_type, qr.quarter
                    ORDER BY qr.year
                )) / LAG(qr.quarterly_revenue) OVER (
                    PARTITION BY qr.taxi_type, qr.quarter
                    ORDER BY qr.year
                ),
                2
            )
            ELSE NULL
        END AS yoy_growth_percent
    FROM quarterly_revenue qr
)
SELECT
    year,
    quarter,
    CONCAT(year, '/Q', quarter) AS year_quarter,
    taxi_type,
    quarterly_revenue,
    previous_year_revenue,
    yoy_growth_percent
FROM yoy_growth
WHERE year = 2020  -- Filter for 2020 as per the question
ORDER BY
    taxi_type,
    year,
    quarter