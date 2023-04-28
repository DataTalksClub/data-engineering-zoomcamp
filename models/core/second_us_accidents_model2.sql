{{ config(
        materialized = "table",
    )
}}

select severity, description, state, weather_condition
from {{ source("staging", "us_accidents") }}
group by severity