{{ config(materialized='table')}}

with trips_data as (
    select 
        tripid, 
        service_type, 
        pickup_datetime, 
        dropoff_datetime, 
        pickup_zone,
        pickup_borough,
        dropoff_zone, 
        dropoff_borough
    from {{ ref('fact_trips') }}
    union all
    select 
        tripid, 
        service_type, 
        pickup_datetime, 
        dropoff_datetime, 
        pickup_zone,
        pickup_borough,
        dropoff_zone, 
        dropoff_borough
    from {{ ref('fact_fhv_trips') }}
)
select 
    service_type, 
    pickup_zone,  
    pickup_datetime, 
    dropoff_datetime
    pickup_borough, 
    dropoff_zone, 
    dropoff_borough, 

    -- Additional calculations
    count(tripid) as total_monthly_trips,

    from trips_data
