with data as (
    
    select * from {{ref('data_url_path')}}
    
)

select

    coalesce({{ dbt_utils.get_url_path('original_url') }}, '') as actual,
    coalesce(parsed_path, '') as expected
    
from data