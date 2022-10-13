with data as (

    select * from {{ ref('data_position') }}

)

select

    {{ dbt_utils.position('substring_text', 'string_text') }} as actual,
    result as expected

from data