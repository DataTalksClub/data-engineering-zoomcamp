{{ config(materialized='table') }}

with trips_data as (
    select * from {{ ref('fact_trips') }}
    union all
    select * from {{ ref('fact_fhv_trips.sql') }}
)
    select 
    -- revenue grouping 
    pickup_zone as revenue_zone,
    {{ dbt.date_trunc("month", "pickup_datetime") }} as revenue_month, 

    service_type, 

    -- Revenue calculation 
    sum(fare_amount, 0) as revenue_monthly_fare,
    sum(extra, 0) as revenue_monthly_extra,
    sum(mta_tax, 0) as revenue_monthly_mta_tax,
    sum(tip_amount, 0) as revenue_monthly_tip_amount,
    sum(tolls_amount, 0) as revenue_monthly_tolls_amount,
    sum(ehail_fee, 0) as revenue_monthly_ehail_fee,
    sum(improvement_surcharge, 0) as revenue_monthly_improvement_surcharge,
    sum(total_amount, 0) as revenue_monthly_total_amount,

    -- Additional calculations
    count(tripid) as total_monthly_trips,
    avg(passenger_coun, 0) as avg_monthly_passenger_count,
    avg(trip_distance, 0) as avg_monthly_trip_distance

    from trips_data
    group by 1,2,3