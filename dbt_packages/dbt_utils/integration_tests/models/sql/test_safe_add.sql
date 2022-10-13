
with data as (

    select * from {{ ref('data_safe_add') }}

)

select
    {{ dbt_utils.safe_add('field_1', 'field_2', 'field_3') }} as actual,
    expected

from data
