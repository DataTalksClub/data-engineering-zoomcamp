-- Homework for Data Engineering Zoomcamp week3, done in July 8th 2025
CREATE OR REPLACE EXTERNAL TABLE `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dtc_de_bucket/yellow_tripdata_2024/*.parquet']
);

-- Use this to create a regular/materialized table
CREATE OR REPLACE TABLE `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_regular` AS
SELECT * FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata`;

-- Run these and verify that the results are equivalent!
SELECT count(*) FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata`;
SELECT count(*) FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_regular`;

-- Just hover over these 2 queries to see the estimated amount of data that will be read. Don't need to run these!
SELECT COUNT(DISTINCT(PULocationID)) FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata`;
SELECT COUNT(DISTINCT(PULocationID)) FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_regular`;

-- Similarly, just hover, don't run!
SELECT PULocationID FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_regular`;
SELECT PULocationID, DOLocationID FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_regular`;

-- Run this!
SELECT COUNT(fare_amount) 
FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata` 
WHERE fare_amount = 0;

-- Create a partitioned and clustered table!
CREATE OR REPLACE TABLE `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_partitioned_clustered`
PARTITION BY DATE(tpep_dropoff_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_regular`;

-- Again, just hover over these two queries and see the estimation !!!
SELECT COUNT(DISTINCT(VendorID))
FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_regular`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT COUNT(DISTINCT(VendorID))
FROM `graphical-fort-463908-u4.dtc_de_dataset.yellow2024_tripdata_partitioned_clustered`
WHERE DATE(tpep_dropoff_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

-- Congrats!
