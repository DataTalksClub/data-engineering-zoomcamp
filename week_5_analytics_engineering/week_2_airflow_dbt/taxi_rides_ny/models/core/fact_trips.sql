{{ config(materialized='table') }}

select   
    stream_id, 
    show_id,
    user_id, 
    category,
    title,
    genres,
    release_year, 
    stream_timestamp,
    stream_duration

from {{ref('stg_vodclickstream_uk_movies')}}

-- dbt run --model <model.sql> --var 'is_test_run: false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}