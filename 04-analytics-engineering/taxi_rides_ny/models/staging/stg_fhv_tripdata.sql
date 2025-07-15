{{ 
    config(
        materialized='view'
    ) 
}}

with tripdata as 
(
  select *,
    row_number() over(partition by dispatching_base_num, pickup_datetime) as rn
  from {{ source('staging','fhv_tripdata_2019') }}
  where dispatching_base_num is not null 
)

select 
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    {{ dbt.safe_cast("dispatching_base_num", api.Column.translate_type("string")) }} as dispatching_base_num,
    {{ dbt.safe_cast("pickup_datetime", api.Column.translate_type("timestamp")) }} as pickup_datetime,
    {{ dbt.safe_cast("dropOff_datetime", api.Column.translate_type("timestamp")) }} as dropoff_datetime,
    {{ dbt.safe_cast("PULocationID", api.Column.translate_type("integer")) }} as PULocationID,
    {{ dbt.safe_cast("DOLocationID", api.Column.translate_type("integer")) }} as DOLocationID,
    {{ dbt.safe_cast("SR_Flag", api.Column.translate_type("string")) }} as SR_Flag,
    {{ dbt.safe_cast("Affiliated_base_number", api.Column.translate_type("string")) }} as Affiliated_base_number
from tripdata
where rn = 1

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}