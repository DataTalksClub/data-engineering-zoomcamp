{{ config(materialized='table')}}

with trips_data as (
    select 
        tripid, 
        pickup_datetime, 
        service_type, 
        dropoff_datetime, 
        pickup_locationid, 
        dropoff_locationid, 
        pickup_zone,
        pickup_borough,
        dropoff_zone, 
        dropoff_borough
    from {{ ref('fact_trips') }}
    union all
    select 
        tripid, 
        pickup_datetime, 
        service_type, 
        dropoff_datetime, 
        pickup_locationid, 
        dropoff_locationid, 
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
    group by 1,2
