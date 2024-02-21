{{ config(materialized="view") }}

with
    fhv_trips_2019 as (
        select *,
        from {{ source("staging", "fhv_tripdata") }}
        where dispatching_base_num is not null
    )

select
    -- identifiers
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'pickup_datetime']) }} as tripid,
    dispatching_base_num,
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }}
    as pickup_locationid,
    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }}
    as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    -- trip info
    sr_flag,
    affiliated_base_number

from fhv_trips_2019
WHERE EXTRACT(YEAR FROM pickup_datetime) = 2019

-- dbt build --select <model.sql> --vars '{'is_test_run: false}'
{% if var("is_test_run", default=true) %} 

limit 100 

{% endif %}
