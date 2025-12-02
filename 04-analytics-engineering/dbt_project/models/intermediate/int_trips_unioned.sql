select * from {{ ref('int_green_tripdata_cleaned') }}
union all
select * from {{ ref('int_yellow_tripdata_cleaned') }}
