{{
    config(
        materialized='view'
    )
}}


select *
from {{ source('staging','yellow_cab_data') }}
limit 10
