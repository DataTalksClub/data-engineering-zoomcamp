{{
    config(
        materialized='table'
    )
}}

select *
from {{ ref('stg_fhv_tripdata') }}