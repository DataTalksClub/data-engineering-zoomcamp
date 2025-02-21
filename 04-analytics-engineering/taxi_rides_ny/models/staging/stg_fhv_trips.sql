{{ config(
    materialized='view'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['dispatching_base_num', 'dispatching_base_num']) }} as tripid,    
    {{ dbt.safe_cast("dispatching_base_num", api.Column.translate_type("string")) }} as dispatching_base_num,
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,
    {{ dbt.safe_cast("SR_Flag", api.Column.translate_type("string")) }} as SR_Flag,
    {{ dbt.safe_cast("Affiliated_base_number", api.Column.translate_type("string")) }} as Affiliated_base_number
FROM {{ source('staging', 'fhv_tripdata') }}
WHERE dispatching_base_num IS NOT NULL