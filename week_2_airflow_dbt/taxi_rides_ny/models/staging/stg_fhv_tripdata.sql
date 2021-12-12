{{ config(materialized='view') }}


select
    dispatching_base_num text COLLATE pg_catalog."default",
    pickup_datetime timestamp without time zone,
    dropoff_datetime timestamp without time zone,
    pulocationid integer,
    dolocationid integer,
    sr_flag integer,
    affiliated_base_number text COLLATE pg_catalog."default"

from {{ source('staging','fhv_tripdata_2021_01') }}

-- dbt run --model <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
