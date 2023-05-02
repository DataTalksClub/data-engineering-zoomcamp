{{ config(
        materialized = "table", 
        cluster_by=["state"]
    )
}}

select * from {{ source("staging", "us_accidents") }}