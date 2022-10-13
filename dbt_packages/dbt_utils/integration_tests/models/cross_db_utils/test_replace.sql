with data as (

    select 
    
        *,
        coalesce(search_chars, '') as old_chars,
        coalesce(replace_chars, '') as new_chars
        
    from {{ ref('data_replace') }}

)

select

    {{ dbt_utils.replace('string_text', 'old_chars', 'new_chars') }} as actual,
    result as expected

from data
