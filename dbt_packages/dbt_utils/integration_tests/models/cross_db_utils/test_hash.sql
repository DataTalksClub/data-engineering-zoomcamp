
with data as (

    select * from {{ ref('data_hash') }}

)

select
    {{ dbt_utils.hash('input_1') }} as actual,
    output as expected

from data
