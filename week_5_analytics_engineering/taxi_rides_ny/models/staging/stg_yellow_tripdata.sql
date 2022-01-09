{{ config(materialized='view') }}


select
    -- identifiers
    vendorid::integer,
    ratecodeid::integer,
    pulocationid::integer,
    dolocationid::integer,
    
    -- timestamps
    lpep_pickup_datetime::timestamp without time zone,
    lpep_dropoff_datetime::timestamp without time zone,
    
    -- trip info
    store_and_fwd_flag text COLLATE pg_catalog."default",
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
    congestion_surcharge::double precision
from {{ source('staging','green_tripdata_2021_01') }}

-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
