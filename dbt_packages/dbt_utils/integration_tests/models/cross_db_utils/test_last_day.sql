
with data as (

    select * from {{ ref('data_last_day') }}

)

select
    case
        when date_part = 'month' then {{ dbt_utils.last_day('date_day', 'month') }}
        when date_part = 'quarter' then {{ dbt_utils.last_day('date_day', 'quarter') }}
        when date_part = 'year' then {{ dbt_utils.last_day('date_day', 'year') }}
        else null
    end as actual,
    result as expected

from data
