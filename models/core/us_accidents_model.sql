{{ config(
        materialized = "table"
    )
}}

select * from {{ source("staging", "us_accidents") }}
limit 50