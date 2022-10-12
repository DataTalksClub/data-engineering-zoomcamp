
-- snowflake doesn't like this as a view because the `generate_series`
-- call creates a CTE called `unioned`, as does the `equality` schema test.
-- Ideally, Snowflake would be smart enough to know that these CTE names are
-- different, as they live in different relations. TODO: use a less common cte name

{{ config(materialized='table') }}

with date_spine as (

    {% if target.type == 'postgres' %}
        {{ dbt_utils.date_spine("day", "'2018-01-01'::date", "'2018-01-10'::date") }}
        
    {% elif target.type == 'bigquery' %}
        select cast(date_day as date) as date_day
        from ({{ dbt_utils.date_spine("day", "'2018-01-01'", "'2018-01-10'") }})
    
    {% else %}
        {{ dbt_utils.date_spine("day", "'2018-01-01'", "'2018-01-10'") }}
    {% endif %}

)

select date_day
from date_spine

