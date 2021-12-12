{{ config(materialized='table') }}


select
	mv.show_id, 
	st.title, 
	mv.genres,  
	mv.release_year,
 	mv.country,  
	mv.rating, 
	mv.duration, 
	round(avg(st.stream_duration),2) as avg_stream_duration, 
	round(avg(st.stream_duration)*100/mv.duration,2) as avg_completion_percentage
from {{ ref('fact_movie_streams') }}  as st
inner join {{ ref('dim_movies') }} as mv
	on mv.title = st.title
	and st.stream_duration <= mv.duration
group by 1,2,3,4,5,6,7