{{ config(
        materialized = "table",
        cluster_by=["Weather_Condition"]
    )
}}

select Weather_Condition, COUNT(*) AS num_accidents, AVG(Severity) as average_Severity
from {{ source("staging", "us_accidents") }}
GROUP BY Weather_Condition