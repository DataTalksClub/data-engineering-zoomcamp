
with data as (

    select * from {{ ref('data_datediff') }}

)

select

    case
        when datepart = 'second' then {{ dbt_utils.datediff('first_date', 'second_date', 'second') }}
        when datepart = 'minute' then {{ dbt_utils.datediff('first_date', 'second_date', 'minute') }}
        when datepart = 'hour' then {{ dbt_utils.datediff('first_date', 'second_date', 'hour') }}
        when datepart = 'day' then {{ dbt_utils.datediff('first_date', 'second_date', 'day') }}
        when datepart = 'week' then {{ dbt_utils.datediff('first_date', 'second_date', 'week') }}
        when datepart = 'month' then {{ dbt_utils.datediff('first_date', 'second_date', 'month') }}
        when datepart = 'year' then {{ dbt_utils.datediff('first_date', 'second_date', 'year') }}
        else null
    end as actual,
    result as expected

from data

-- Also test correct casting of literal values.

union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "microsecond") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "millisecond") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "second") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "minute") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "hour") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "day") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-03 00:00:00.000000'", "week") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "month") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "quarter") }} as actual, 1 as expected
union all select {{ dbt_utils.datediff("'1999-12-31 23:59:59.999999'", "'2000-01-01 00:00:00.000000'", "year") }} as actual, 1 as expected
