
with data as (

    select * from {{ ref('data_concat') }}

)

select
    {{ dbt_utils.concat(['input_1', 'input_2']) }} as actual,
    output as expected

from data
