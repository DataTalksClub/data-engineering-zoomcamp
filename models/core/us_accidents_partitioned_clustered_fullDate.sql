{{ config(
        materialized = "table",
        partition_by={
            "field": "StartTime",
            "data_type": "date",
            "granularity": "year"
        }, 
        cluster_by=["state"]
    )
}}

select
    cast(state as string) as State,
    cast(Start_Time AS DATE) AS StartTime,
    cast(severity as integer) as Severity,
    cast(ID as string) as ID,
    cast(Weather_condition as string) as Weather_condition
from {{ source("staging", "us_accidents") }}