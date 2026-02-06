Data Engineering Zoomcamp 2026 - Week 3 Homework

Commands used: 
gcloud storage cp yellow_tripdata_2024-*.parquet gs://de-zoomcamp-module3-bucket/
gcloud storage ls gs://de-zoomcamp-module3-bucket/

Queries used: 
-- SELECT COUNT(distinct PULocationID) FROM `zoomcamp.yellow_tripdata_non_partitioned`

-- CREATE OR REPLACE EXTERNAL TABLE `de-engineering-zoomcamp-486403.zoomcamp.yellow_taxi_external`
-- OPTIONS (
--   format = 'PARQUET',
--   uris = ['gs://de-zoomcamp-module3-bucket/yellow_tripdata_2024-*.parquet']
-- );

-- CREATE OR REPLACE TABLE de-engineering-zoomcamp-486403.zoomcamp.yellow_tripdata_non_partitioned AS
-- SELECT * FROM de-engineering-zoomcamp-486403.zoomcamp.yellow_taxi_external;

-- select count(*) from de-engineering-zoomcamp-486403.zoomcamp.yellow_tripdata_non_partitioned;

-- SELECT COUNT(distinct PULocationID) FROM `zoomcamp.yellow_taxi_external`

-- SELECT 'external' AS table_name, COUNT(DISTINCT PULocationID) AS dist_pu_loc
-- FROM
--   zoomcamp.yellow_taxi_external
-- UNION ALL
-- SELECT
--   'non_partitioned' AS table_name, COUNT(DISTINCT PULocationID) AS dist_pu_loc
-- FROM
--   `zoomcamp.yellow_tripdata_non_partitioned`

-- select PULocationID, DOLocationID from `zoomcamp.yellow_tripdata_non_partitioned`;

-- select count(*) from `zoomcamp.yellow_tripdata_non_partitioned` where fare_amount = 0;

-- create table zoomcamp.yellow_tripdata_optimized
-- partition by date(tpep_dropoff_datetime)
-- cluster by vendorID as
-- select * from `zoomcamp.yellow_tripdata_non_partitioned`

-- SELECT vendorID
-- FROM `zoomcamp.yellow_tripdata_non_partitioned`
-- WHERE
--   tpep_dropoff_datetime >= timestamp('2024-03-01')
--   AND tpep_dropoff_datetime < timestamp('2024-03-16')

-- SELECT vendorID
-- FROM `zoomcamp.yellow_tripdata_optimized`
-- WHERE
--   tpep_dropoff_datetime >= timestamp('2024-03-01')
--   AND tpep_dropoff_datetime < timestamp('2024-03-16')

-- Select count(*) from `zoomcamp.yellow_tripdata_optimized`;

SELECT COUNT(*) FROM `zoomcamp.yellow_tripdata_non_partitioned`;
