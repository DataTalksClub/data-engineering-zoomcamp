{{
    config(
        materialized='view'
    )
}}

with tripdata as 
(
  select *

  from {{ source('staging','fhv_taxi_data') }}
  where dispatching_base_num is not null 
  and EXTRACT(YEAR FROM pickup_datetime)=2019

)
select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    dispatching_base_num,
    {{ dbt.safe_cast("PULocationID", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("DOLocationID", api.Column.translate_type("integer")) }} as dropoff_locationid,
    
    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    --TIMESTAMP_MICROS(CAST(pickup_datetime / 1000 AS INT64)) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,
    --TIMESTAMP_MICROS(CAST(dropoff_datetime / 1000 AS INT64)) as dropoff_datetime,
    
    -- trip info
    SR_Flag,
    Affiliated_base_number
from tripdata

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}