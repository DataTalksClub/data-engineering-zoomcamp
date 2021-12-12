{{ config(materialized='table') }}

select   
  show_id, 
  category,
  title, 
  director,
  principal_cast, 
  country, 
  release_year,
  rating,
  duration, 
  genres
from {{ref('stg_netflix_titles')}}
where category = 'Movie'
-- dbt run --model <model.sql> --var 'is_test_run:false'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}