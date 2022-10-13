
with data as (

    select * from {{ ref('data_split_part') }}

)

select
    {{ dbt_utils.split_part('parts', 'split_on', 1) }} as actual,
    result_1 as expected

from data

union all

select
    {{ dbt_utils.split_part('parts', 'split_on', 2) }} as actual,
    result_2 as expected

from data

union all

select
    {{ dbt_utils.split_part('parts', 'split_on', 3) }} as actual,
    result_3 as expected

from data
