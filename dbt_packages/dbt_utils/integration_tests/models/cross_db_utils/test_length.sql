with data as (

    select * from {{ ref('data_length') }}

)

select

    {{ dbt_utils.length('expression') }} as actual,
    output as expected

from data