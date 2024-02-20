{{ config(
    materialized='table',
    partition_by={
      "field": "trips_month",
      "data_type": "timestamp",
      "granularity": "month"
    },
    cluster_by = "service_type"
)}}

with trips_data as (
    select 
        tripid, 
        pickup_datetime, 
        dropoff_datetime, 
        pickup_locationid, 
        dropoff_locationid, 
        pickup_zone,
        service_type
    from {{ ref('fact_trips') }}
    union all
    select 
        tripid, 
        pickup_datetime, 
        dropoff_datetime, 
        pickup_locationid, 
        dropoff_locationid, 
        pickup_zone,
        service_type 
    from {{ ref('fact_fhv_trips') }}
)
    select 
    -- revenue grouping 
    pickup_zone as trips_zone,
    {{ dbt.date_trunc("month", "pickup_datetime") }} as trips_month, 

    service_type, 

    -- Additional calculations
    count(tripid) as total_monthly_trips,

    from trips_data
    group by 1,2,3
