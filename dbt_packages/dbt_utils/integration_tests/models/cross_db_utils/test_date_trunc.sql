
with data as (

    select * from {{ ref('data_date_trunc') }}

)

select
    cast({{dbt_utils.date_trunc('day', 'updated_at') }} as date) as actual,
    day as expected

from data

union all

select
    cast({{ dbt_utils.date_trunc('month', 'updated_at') }} as date) as actual,
    month as expected

from data
