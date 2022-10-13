with data as (

    select * from {{ ref('data_right') }}

)

select

    {{ dbt_utils.right('string_text', 'length_expression') }} as actual,
    coalesce(output, '') as expected

from data