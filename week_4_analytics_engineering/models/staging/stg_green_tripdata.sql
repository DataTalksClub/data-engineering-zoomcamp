{{ config(materialized='view') }}

select * from {{ source('staging','external_green_tripdata') }} limit 100
