-- create or replace external table `de-trainig.dezoomcamp.fhv_2019` 
-- options (
--   format = 'CSV',
--   uris = ['gs://dtc_data_lake_de-trainig/data/fhv/*.csv.gz']
-- );

-- select count(*) from `dezoomcamp.fhv_2019`

-- create table `dezoomcamp.fhv_2019bq` as (
-- select * from `dezoomcamp.fhv_2019`)

-- select distinct count(Affiliated_base_number) from `dezoomcamp.fhv_2019bq`

-- select distinct count(Affiliated_base_number) from `dezoomcamp.fhv_2019`


-- select count(*) from `dezoomcamp.fhv_2019bq`
-- where PUlocationID is null and DOlocationID is null


-- create table `dezoomcamp.fhv_2019_pq` 
-- partition by date(pickup_datetime)
-- cluster by Affiliated_base_number
-- as 
-- select * from `dezoomcamp.fhv_2019bq`

select distinct affiliated_base_number 
from `dezoomcamp.fhv_2019_pq` 
where date(pickup_datetime) between '2019-03-01' and '2019-03-31'