
-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `crested-photon-302113.zoomcamp.external_green_tripdata_2022` 
(VendorID INT64,
lpep_pickup_datetime DATETIME,
lpep_dropoff_datetime DATETIME,
store_and_fwd_flag STRING,
RatecodeID FLOAT64,
PULocationID INT64,
DOLocationID INT64,
passenger_count FLOAT64,
trip_distance FLOAT64,
fare_amount FLOAT64,
extra FLOAT64,
mta_tax FLOAT64,
tip_amount FLOAT64,
tolls_amount FLOAT64,
ehail_fee INT64,
improvement_surcharge FLOAT64,
total_amount FLOAT64,
payment_type FLOAT64,
trip_type FLOAT64,
congestion_surcharge FLOAT64
)
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://kestra-de-zoomcamp/merged_nyc_taxi.parquet']
);


-- Create a table in BQ using the Green Taxi Trip Records for 2022 (do not partition or cluster this table).
CREATE TABLE zoomcamp.green_tripdata_2022 AS
SELECT * FROM `crested-photon-302113.zoomcamp.external_green_tripdata_2022`





