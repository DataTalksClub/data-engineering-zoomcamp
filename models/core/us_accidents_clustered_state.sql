{{ config(
        materialized = "table",
        cluster_by=["State"]
    )
}}

select State, COUNT(*) AS num_accidents, AVG(Severity) as average_Severity
from {{ source("staging", "us_accidents") }}
GROUP BY State