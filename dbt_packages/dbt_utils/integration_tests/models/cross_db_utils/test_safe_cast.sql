
with data as (

    select * from {{ ref('data_safe_cast') }}

)

select
    {{ dbt_utils.safe_cast('field', dbt_utils.type_string()) }} as actual,
    output as expected

from data
