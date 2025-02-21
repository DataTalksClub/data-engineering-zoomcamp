{{ config(materialized="table") }}

with
    fhv_trips as (select * from {{ ref("dim_fhv_trips") }}),

    fhv_trips_with_duration as (
        select
            tripid,
            dispatching_base_num,
            pickup_datetime,
            extract(year from pickup_datetime) as year,
            extract(month from pickup_datetime) as month,
            dropoff_datetime,
            timestamp_diff(
                cast(dropoff_datetime as timestamp),
                cast(pickup_datetime as timestamp),
                second
            ) as trip_duration,
            pickup_zone,
            dropoff_zone
        from fhv_trips
    ),

    monthly_percentiles as (
        select
            year,
            month,
            pickup_zone,
            dropoff_zone,
            percentile_cont(trip_duration, 0.90) over (
                partition by year, month, pickup_zone, dropoff_zone
            ) as p90_trip_duration,
            count(1) over (
                partition by year, month, pickup_zone, dropoff_zone
            ) as trip_count
        from fhv_trips_with_duration
    ),

    monthly_percentiles_ordered as (
        select distinct
            year,
            month,
            pickup_zone,
            dropoff_zone,
            round(p90_trip_duration, 0) as p90_trip_duration,
            trip_count
        from monthly_percentiles
        order by year, month, pickup_zone, dropoff_zone
    ),

    nov_2019_ranked as (
        select
            pickup_zone,
            dropoff_zone,
            p90_trip_duration,
            row_number() over (
                partition by pickup_zone order by p90_trip_duration desc
            ) as duration_rank
        from monthly_percentiles_ordered
        where
            year = 2019
            and month = 11
            and pickup_zone in ('Newark Airport', 'SoHo', 'Yorkville East')
    )

select distinct pickup_zone, dropoff_zone, p90_trip_duration
from nov_2019_ranked
where duration_rank = 2  -- 2nd longest P90
order by pickup_zone, p90_trip_duration desc
