{{ config(
        materialized = "table"
    )
}}

select
    cast(state as string) as State,
    left((cast (StartTime as string)), 4) as Year_time,
    cast(severity as integer) as Severity,
    cast(ID as string) as ID,
    cast(Weather_condition as string) as Weather_condition,
from {{ source("staging", "us_accidents_partitioned_clustered") }}
order by Year_time