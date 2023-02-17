{{ config(materialized='view') }}

select
    -- identifiers
    {{ dbt_utils.surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    cast(dispatching_base_num as string) as vendorid,
    cast(pulocationid as integer) as pickup_locationid,
    cast(dolocationid as integer) as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- trip info
    sr_flag
    

from {{ source('staging','fhv_tripdata') }}
where dispatching_base_num is not null 

{% if var('is_test_run', default=true) %}

    limit 100

{% endif %}

