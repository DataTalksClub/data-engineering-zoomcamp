-- CREATE EXTERNAL TABLE  de_zoomcamp.fhv
-- OPTIONS (
--   uris = ['gs://first_prefect_bucket_ekansh/data/fhv/fhv_tripdata*.csv.gz'],
--   format = 'CSV')

-- SELECT COUNT(*) FROM `de_zoomcamp.fhv`

-- SELECT COUNT(DISTINCT(Affiliated_base_number)) FROM `de-zoomcamp-376518.de_zoomcamp.fhv` 

-- SELECT COUNT(DISTINCT(Affiliated_base_number)) FROM `de-zoomcamp-376518.de_zoomcamp.fhv_native` 

-- SELECT COUNT(*)  
-- FROM `de-zoomcamp-376518.de_zoomcamp.fhv_native` 
-- WHERE PUlocationID IS NULL
-- AND DOlocationID IS NULL;

-- CREATE OR REPLACE TABLE de-zoomcamp-376518.de_zoomcamp.fhv_partitoned_clustered
-- PARTITION BY DATE(pickup_datetime) 
-- CLUSTER BY affiliated_base_number AS
-- SELECT * FROM de-zoomcamp-376518.de_zoomcamp.fhv;

-- SELECT COUNT(DISTINCT(affiliated_base_number))
-- FROM de-zoomcamp-376518.de_zoomcamp.fhv_native
-- WHERE DATE(pickup_datetime) BETWEEN '2019-03-01' AND '2019-03-31';

