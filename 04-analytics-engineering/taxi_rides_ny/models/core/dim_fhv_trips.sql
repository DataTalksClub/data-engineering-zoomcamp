{{ config(materialized="table") }}

with
    fhv_tripdata as (
        select *, 'FHV' as service_type from {{ ref("stg_fhv_trips") }}
    ),

    dim_zones as (select * from {{ ref("dim_zones") }} where borough != 'Unknown')

select
    fhv_tripdata.tripid,
    fhv_tripdata.dispatching_base_num,
    fhv_tripdata.pickup_datetime,
    extract(year from fhv_tripdata.pickup_datetime) as year,
    extract(month from fhv_tripdata.pickup_datetime) as month,
    fhv_tripdata.dropoff_datetime,
    fhv_tripdata.pickup_locationid,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    fhv_tripdata.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    fhv_tripdata.sr_flag,
    fhv_tripdata.affiliated_base_number

from fhv_tripdata

inner join
    dim_zones as pickup_zone on fhv_tripdata.pickup_locationid = pickup_zone.locationid

inner join
    dim_zones as dropoff_zone
    on fhv_tripdata.dropoff_locationid = dropoff_zone.locationid
