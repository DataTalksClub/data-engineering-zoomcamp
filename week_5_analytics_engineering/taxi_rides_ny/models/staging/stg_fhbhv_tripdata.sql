{{ config(materialized='view') }}


select
    hvfhs_license_num::varchar,
    dispatching_base_num::varchar,
    pickup_datetime::timestamp without time zone,
    dropoff_datetime::timestamp without time zone,
    pulocationid::integer,
    dolocationid::integer,
    sr_flag::integer
from {{ source('staging','fhvhv_tripdata_2021_01') }}

-- dbt build --m <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}
