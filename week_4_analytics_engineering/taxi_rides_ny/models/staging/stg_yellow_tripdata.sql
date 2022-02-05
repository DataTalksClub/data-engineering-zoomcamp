{{ config(materialized='view') }}


select
   -- identifiers
    {{ dbt_utils.surrogate_key(['vendorid', 'tpep_pickup_datetime']) }} as tripid,
    cast(vendorid as integer) as vendorid,
    cast(ratecodeid as integer) as ratecodeid,
    cast(pulocationid as integer) as  pickup_locationid,
    cast(dolocationid as integer) as dropoff_locationid,
    
    -- timestamps
    cast(tpep_pickup_datetime as timestamp) as pickup_datetime,
    cast(tpep_dropoff_datetime as timestamp) as dropoff_datetime,
    
    -- trip info
    cast(store_and_fwd_flag as varchar) as store_and_fwd_flag,
    cast(passenger_count as integer) as passenger_count,
    cast(trip_distance as double precision) as trip_distance,
    -- yellow cabs are always street-hail
    1 as trip_type,
    
    -- payment info
    cast(fare_amount as double precision) as fare_amount,
    cast(extra as double precision) as extra,
    cast(mta_tax as double precision) as mta_tax,
    cast(tip_amount as double precision) as tip_amount,
    cast(tolls_amount as double precision) as tolls_amount,
     0 as ehail_fee,
    cast(improvement_surcharge as double precision) as improvement_surcharge,
    cast(total_amount as double precision) as total_amount,
    cast(payment_type as integer) as payment_type,
    {{ get_payment_type_description('payment_type') }} as payment_type_description, 
    cast(congestion_surcharge as double precision) as congestion_surcharge
from {{ source('staging','yellow_tripdata_2021_01') }}
where vendorid is not null 
  -- qualify row_number() over(partition by tripid) = 1

-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
