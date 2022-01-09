{{ config(materialized='view') }}


select
    -- identifiers
    {{ dbt_utils.surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as tripid,
    vendorid::integer,
    ratecodeid::integer,
    pulocationid::integer as pickup_locationid,
    dolocationid::integer as dropoff_locationid,
    
    -- timestamps
    lpep_pickup_datetime::timestamp without time zone as pickup_datetime,
    lpep_dropoff_datetime::timestamp without time zone as dropoff_datetime,
    
    -- trip info
    store_and_fwd_flag::varchar,
    passenger_count::integer,
    trip_distance::double precision,
    trip_type::integer,
    
    -- payment info
    fare_amount::double precision,
    extra::double precision,
    mta_tax::double precision,
    tip_amount::double precision,
    tolls_amount::double precision,
    ehail_fee::integer,
    improvement_surcharge::double precision,
    total_amount::double precision,
    payment_type::integer,
    {{ get_payment_type_description('payment_type') }} as payment_type_description, 
    congestion_surcharge::double precision
from {{ source('staging','green_tripdata_2021_01') }}
where vendorid is not null 
  -- qualify row_number() over(partition by tripid) = 1

-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
