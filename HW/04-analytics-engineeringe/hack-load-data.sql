-- MAKE SURE YOU REPLACE PROJECT_ID WITH THE NAME OF YOUR DATASET! 
-- When you run the query, only run 5 of the ALTER TABLE statements at one time (by highlighting only 5). 
-- Otherwise BigQuery will say too many alterations to the table are being made.
I've followed the recommended manual procedure to load the data into BigQuery for Week 04.

 - [Hack for loading data to BigQuery for Week 4](https://www.youtube.com/watch?v=Mork172sK_c&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs): step-by-step instructions. Watch the whole video, there are some additional steps at the end.

 - [hack-load-data.sql](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/taxi_rides_ny/analyses/hack-load-data.sql): SQL to create, append, and alter the tables. Below is my version of it.

1. On Google Cloud, open BigQuery Studio. Make sure you have selected the right project, so you don't need to inform the project id in the SQL commands below.

2. In BigQuery, create a `trips_data_all` dataset in the US Multiregion.

3. Create the green_trip_data and yellow_trip_data tables with data from 2019:

CREATE TABLE  `PROJECT_ID.trips_data_all.green_trip_data` AS
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2019`; 


CREATE TABLE  `PROJECT_ID.trips_data_all.yellow_trip_data` AS
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2019`;

INSERT INTO  `PROJECT_ID.trips_data_all.green_trip_data` 
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2020` ;


INSERT INTO  `PROJECT_ID.trips_data_all.yellow_trip_data` 
SELECT * FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2020`; 

4.  -- Fixes yellow table schema
ALTER TABLE `PROJECT_ID.trips_data_all.yellow_trip_data`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `PROJECT_ID.trips_data_all.yellow_trip_data`
  RENAME COLUMN pickup_datetime TO tpep_pickup_datetime;
ALTER TABLE `PROJECT_ID.trips_data_all.yellow_trip_data`
  RENAME COLUMN dropoff_datetime TO tpep_dropoff_datetime;
ALTER TABLE `PROJECT_ID.trips_data_all.yellow_trip_data`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `PROJECT_ID.trips_data_all.yellow_trip_data`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;

ALTER TABLE `PROJECT_ID.trips_data_all.yellow_trip_data`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `PROJECT_ID.trips_data_all.yellow_trip_data`
  RENAME COLUMN dropoff_location_id TO DOLocationID;

5.  -- Fixes green table schema
ALTER TABLE `PROJECT_ID.trips_data_all.green_trip_data`
  RENAME COLUMN vendor_id TO VendorID;
ALTER TABLE `PROJECT_ID.trips_data_all.green_trip_data`
  RENAME COLUMN pickup_datetime TO lpep_pickup_datetime;
ALTER TABLE `PROJECT_ID.trips_data_all.green_trip_data`
  RENAME COLUMN dropoff_datetime TO lpep_dropoff_datetime;
ALTER TABLE `PROJECT_ID.trips_data_all.green_trip_data`
  RENAME COLUMN rate_code TO RatecodeID;
ALTER TABLE `PROJECT_ID.trips_data_all.green_trip_data`
  RENAME COLUMN imp_surcharge TO improvement_surcharge;

ALTER TABLE `PROJECT_ID.trips_data_all.green_trip_data`
  RENAME COLUMN pickup_location_id TO PULocationID;
ALTER TABLE `PROJECT_ID.trips_data_all.green_trip_data`
  RENAME COLUMN dropoff_location_id TO DOLocationID;

6. -- fhv trip data
CREATE OR REPLACE EXTERNAL TABLE `PROJECT_ID.trips_data_all.fhv_trip_data_2019`
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://week3-data-ware-house/fhv/fhv_tripdata_2019-*.parquet']
);

CREATE OR REPLACE EXTERNAL TABLE `PROJECT_ID.trips_data_all.fhv_trip_data` (
  dispatching_base_num STRING,
  pickup_datetime DATETIME,
  dropoff_datetime DATETIME,
  PUlocationID FLOAT64,
  DOlocationID FLOAT64,
  SR_Flag FLOAT64,
  Affiliated_base_number STRING
)
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://week3-data-ware-house/fhv/fhv_tripdata_2019-*.parquet']
);

SELECT COUNT(1) FROM `PROJECT_ID.trips_data_all.fhv_trip_data`;

SELECT * FROM `PROJECT_ID.trips_data_all.fhv_trip_data` LIMIT 500;

SELECT * REPLACE (
  CAST(0 AS FLOAT64) AS SR_Flag
) FROM `PROJECT_ID.trips_data_all.fhv_trip_data` LIMIT 500;


SELECT COUNT(1) FROM `PROJECT_ID.dbt_dj_production.fact_trips`;
SELECT COUNT(1) FROM `PROJECT_ID.dbt_dj_production.taxi_zone_lookup`;

SELECT COUNT(1) FROM `PROJECT_ID.dbt_ny_taxi.stg_green_trip_data`;
SELECT COUNT(1) FROM `PROJECT_ID.dbt_ny_taxi.stg_yellow_trip_data`;

SELECT DISTINCT (Payment_type) FROM `PROJECT_ID.trips_data_all.green_trip_data`;
SELECT DISTINCT (Payment_type) FROM `PROJECT_ID.trips_data_all.yellow_trip_data`;





