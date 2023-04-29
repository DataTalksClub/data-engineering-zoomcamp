{{ config(
        materialized = "table"
    )
}}

select
    cast(state as string) as State,
    left(start_time, 4) as Year_time,
    cast(severity as integer) as Severity,
    cast(description as string) as Description,
    cast(weather_condition as string) as Weather_condition
from {{ source("staging", "us_accidents") }}


