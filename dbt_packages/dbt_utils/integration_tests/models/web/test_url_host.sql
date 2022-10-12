with data as (
    
    select * from {{ref('data_url_host')}}
    
)

select

    {{ dbt_utils.get_url_host('original_url') }} as actual,
    parsed_url as expected
    
from data