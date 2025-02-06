CREATE OR REPLACE EXTERNAL TABLE `robotic-incline-449301-g8.zoomcamp.external_yellow_tripdata_2024`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dezoomcamp_hw3_202502/yellow_tripdata_2024-*.parquet']
);

-- check loaded external table
SELECT * FROM robotic-incline-449301-g8.zoomcamp.external_yellow_tripdata_2024 LIMIT 10;

-- create a non-partitioned table from external table
CREATE OR REPLACE TABLE robotic-incline-449301-g8.zoomcamp.yellow_tripdata_non_partitoned_2024 AS
SELECT * FROM robotic-incline-449301-g8.zoomcamp.external_yellow_tripdata_2024;

-- Q1: What is count of records for the 2024 Yellow Taxi Data?
SELECT COUNT(*) FROM robotic-incline-449301-g8.zoomcamp.external_yellow_tripdata_2024;

-- Q2:
SELECT COUNT(DISTINCT PULocationID) FROM robotic-incline-449301-g8.zoomcamp.external_yellow_tripdata_2024;
SELECT COUNT(DISTINCT PULocationID) FROM robotic-incline-449301-g8.zoomcamp.yellow_tripdata_non_partitoned_2024;

-- Q3:
SELECT COUNT(DISTINCT PULocationID) FROM robotic-incline-449301-g8.zoomcamp.yellow_tripdata_non_partitoned_2024;
SELECT COUNT(DISTINCT PULocationID), COUNT(DISTINCT DOLocationID) FROM robotic-incline-449301-g8.zoomcamp.yellow_tripdata_non_partitoned_2024;

-- Q4:
SELECT COUNT(*) FROM robotic-incline-449301-g8.zoomcamp.yellow_tripdata_non_partitoned_2024 WHERE fare_amount = 0;

-- Q5:
-- Creating a partition and cluster table
CREATE OR REPLACE TABLE robotic-incline-449301-g8.zoomcamp.yellow_tripdata_partitoned_clustered_2024
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM robotic-incline-449301-g8.zoomcamp.external_yellow_tripdata_2024;

-- Q6:
SELECT DISTINCT VendorID FROM robotic-incline-449301-g8.zoomcamp.yellow_tripdata_non_partitoned_2024 
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';
SELECT DISTINCT VendorID FROM robotic-incline-449301-g8.zoomcamp.yellow_tripdata_partitoned_clustered_2024 
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Q9:
SELECT COUNT(*) FROM robotic-incline-449301-g8.zoomcamp.yellow_tripdata_non_partitoned_2024;