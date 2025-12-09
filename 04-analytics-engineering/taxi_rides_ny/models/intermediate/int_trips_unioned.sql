-- Combine green and yellow taxi trips into a single dataset
-- UNION ALL is used instead of UNION to preserve all rows (including duplicates across services)
-- Both sources have identical schemas after the cleaning transformations

select * from {{ ref('int_green_tripdata_cleaned') }}
union all
select * from {{ ref('int_yellow_tripdata_cleaned') }}
