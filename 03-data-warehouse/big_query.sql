-- Query public available table
SELECT station_id, name FROM
    bigquery-public-data.new_york_citibike.citibike_stations
LIMIT 100;


-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `taxi-rides-ny.nytaxi.external_yellow_tripdata`
OPTIONS (
  format = 'CSV',
  uris = ['gs://nyc-tl-data/trip data/yellow_tripdata_2019-*.csv', 'gs://nyc-tl-data/trip data/yellow_tripdata_2020-*.csv']
);

-- Check yello trip data
SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata limit 10;

-- Create a non partitioned table from external table
<<<<<<< HEAD
CREATE OR REPLACE TABLE taxi-rides-ny.nytaxi.yellow_tripdata_non_partitioned AS
=======
CREATE OR REPLACE TABLE taxi-rides-ny.nytaxi.yellow_tripdata_non_partitoned AS
>>>>>>> parent of 0678709 (Completed module 3 including homework)
SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata;


-- Create a partitioned table from external table
<<<<<<< HEAD
CREATE OR REPLACE TABLE taxi-rides-ny.nytaxi.yellow_tripdata_partitioned
=======
CREATE OR REPLACE TABLE taxi-rides-ny.nytaxi.yellow_tripdata_partitoned
>>>>>>> parent of 0678709 (Completed module 3 including homework)
PARTITION BY
  DATE(tpep_pickup_datetime) AS
SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata;

-- Impact of partition
-- Scanning 1.6GB of data
SELECT DISTINCT(VendorID)
<<<<<<< HEAD
FROM taxi-rides-ny.nytaxi.yellow_tripdata_non_partitioned
=======
FROM taxi-rides-ny.nytaxi.yellow_tripdata_non_partitoned
>>>>>>> parent of 0678709 (Completed module 3 including homework)
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Scanning ~106 MB of DATA
SELECT DISTINCT(VendorID)
<<<<<<< HEAD
FROM taxi-rides-ny.nytaxi.yellow_tripdata_partitioned
=======
FROM taxi-rides-ny.nytaxi.yellow_tripdata_partitoned
>>>>>>> parent of 0678709 (Completed module 3 including homework)
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2019-06-30';

-- Let's look into the partitions
SELECT table_name, partition_id, total_rows
FROM `nytaxi.INFORMATION_SCHEMA.PARTITIONS`
<<<<<<< HEAD
WHERE table_name = 'yellow_tripdata_partitioned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE taxi-rides-ny.nytaxi.yellow_tripdata_partitioned_clustered
=======
WHERE table_name = 'yellow_tripdata_partitoned'
ORDER BY total_rows DESC;

-- Creating a partition and cluster table
CREATE OR REPLACE TABLE taxi-rides-ny.nytaxi.yellow_tripdata_partitoned_clustered
>>>>>>> parent of 0678709 (Completed module 3 including homework)
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM taxi-rides-ny.nytaxi.external_yellow_tripdata;

-- Query scans 1.1 GB
SELECT count(*) as trips
<<<<<<< HEAD
FROM taxi-rides-ny.nytaxi.yellow_tripdata_partitioned
=======
FROM taxi-rides-ny.nytaxi.yellow_tripdata_partitoned
>>>>>>> parent of 0678709 (Completed module 3 including homework)
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

-- Query scans 864.5 MB
SELECT count(*) as trips
<<<<<<< HEAD
FROM taxi-rides-ny.nytaxi.yellow_tripdata_partitioned_clustered
=======
FROM taxi-rides-ny.nytaxi.yellow_tripdata_partitoned_clustered
>>>>>>> parent of 0678709 (Completed module 3 including homework)
WHERE DATE(tpep_pickup_datetime) BETWEEN '2019-06-01' AND '2020-12-31'
  AND VendorID=1;

