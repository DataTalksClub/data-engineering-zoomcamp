{{ config(
        materialized = "table"
    )
}}

select * from {{ source("staging", "us_accidents") }}
group by state