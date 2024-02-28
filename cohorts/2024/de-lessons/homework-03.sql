

-- import data from `mage-zoomcamp-ellacharmed.nyc_taxi_data.parquet`
-- Creating external table referring to gcs path
-- code snippet from 03-data-warehouse/big_query.sql
CREATE OR REPLACE EXTERNAL TABLE `nyc-rides-ella.ny_taxi.external_green_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://mage-zoomcamp-ellacharmed/green_trips_data.parquet']
);

-- confirm row count is same from mage
SELECT COUNT(*) FROM `nyc-rides-ella.ny_taxi.external_green_tripdata`;

-- qn1 Create a non partitioned table from external table
CREATE OR REPLACE TABLE `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned` AS
SELECT * 
FROM `nyc-rides-ella.ny_taxi.external_green_tripdata`;

-- confirm row count is same external table
SELECT COUNT(*) FROM `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned`;


-- qn 2, turn off cache results in query settins, select and view estimate
SELECT DISTINCT(pulocation_id) 
FROM `nyc-rides-ella.ny_taxi.external_green_tripdata`;

SELECT DISTINCT(pulocation_id) 
FROM `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned`;

-- just playing with more results
SELECT 
    DISTINCT(PULocationID) as locationID,
    COUNT(*) as count_loc
FROM `nyc-rides-ella.ny_taxi.green_cab_2022`
GROUP BY `PULocationID`;
-- ORDER BY count_loc ASC
-- LIMIT 10;

-- qn 3 row count for trips with 0 fare_amount
SELECT COUNT(*)
FROM `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned`
WHERE fare_amount=0;


-- qn 4 create table with the strategy:
-- Partition by lpep_pickup_datetime  Cluster on PUlocationID
CREATE OR REPLACE TABLE `nyc-rides-ella.ny_taxi.green_trips_2022_optimized`
PARTITION BY DATE(lpep_pickup_dt)
CLUSTER BY pulocation_id AS
SELECT *, 
  TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 AS INT64)) AS lpep_pickup_dt, 
  TIMESTAMP_MICROS(CAST(lpep_dropoff_datetime / 1000 AS INT64)) AS lpep_dropoff_dt 
FROM `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned`;


-- qn5 retrieve the distinct PULocationID 
-- between lpep_pickup_datetime 06/01/2022 and 06/30/2022 (inclusive)

SELECT 
  DISTINCT(pulocation_id)
FROM 
  `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned`
WHERE 
  lpep_pickup_date >= "2022-06-01" and 
  lpep_pickup_date <= "2022-07-01"
;

SELECT 
  DISTINCT(pulocation_id)
FROM 
  `nyc-rides-ella.ny_taxi.green_trips_2022_optimized`
WHERE 
  lpep_pickup_dt >= "2022-06-01" and 
  lpep_pickup_dt <= "2022-07-01"
;

-- qn 8 Write a `SELECT count(*)` query FROM the materialized table you created. 
-- How many bytes does it estimate will be read?

SELECT count(*)
FROM `nyc-rides-ella.ny_taxi.green_trips_2022_optimized`;

-- explorations
SELECT CURRENT_DATETIME() as now;
SELECT
  DATETIME "2008-12-25 15:30:00" as original,
  DATETIME_TRUNC(DATETIME "2008-12-25 15:30:00", DAY) as truncated;


-- esperimenting on datetime columns
CREATE OR REPLACE TABLE `nyc-rides-ella.ny_taxi.green_trips_2022_optimized`
PARTITION BY DATETIME_TRUNC(
  PARSE_DATETIME('%Y-%m-%d %H:%M:%S.%f', `lpep_pickup_datetime`), DAY)
CLUSTER BY PULocationID
AS
SELECT *
FROM `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned`;


CREATE OR REPLACE TABLE `nyc-rides-ella.ny_taxi.green_trips_2022_optimized`
PARTITION BY TIMESTAMP_TRUNC(`lpep_pickup_datetime`, DAY) AS
SELECT *
FROM `nyc-rides-ella.ny_taxi.green_trips_2022_non_partitioned`;

