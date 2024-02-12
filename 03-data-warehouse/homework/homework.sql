--1.Count of records for the 2022 Green Taxi Data
CREATE OR REPLACE TABLE data-engineering-project2023.ny_taxi.green_tripdata_non_partitoned AS
SELECT * FROM data-engineering-project2023.ny_taxi.external_green_tripdata;

--2.Estimated amount of data that will be read when this query is executed on the External Table and the Table
SELECT DISTINCT(PULocationID)
FROM 'data-engineering-project2023.ny_taxi.external_green_tripdata'
--6.41MB
SELECT DISTINCT(PULocationID) 
FROM `data-engineering-project2023.ny_taxi.green_tripdata_non_partitoned` 

--3.
SELECT count(*) as trips
FROM data-engineering-project2023.ny_taxi.green_tripdata_partitoned_clustered
WHERE fare_amount=0;

-- 4,5 Creating a partition and cluster tables
CREATE OR REPLACE TABLE data-engineering-project2023.ny_taxi.green_tripdata_partitoned1_clustered1
PARTITION BY PUlocationID
CLUSTER BY date(lpep_pickup_datetime) AS
SELECT * FROM data-engineering-project2023.ny_taxi.external_green_tripdata;

CREATE OR REPLACE TABLE data-engineering-project2023.ny_taxi.green_tripdata_partitoned2_clustered2
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM data-engineering-project2023.ny_taxi.external_green_tripdata;

CREATE OR REPLACE TABLE data-engineering-project2023.ny_taxi.green_tripdata_partitoned3_clustered3
PARTITION BY lpep_pickup_datetime,PUlocationID AS
SELECT * FROM data-engineering-project2023.ny_taxi.external_green_tripdata;

CREATE OR REPLACE TABLE data-engineering-project2023.ny_taxi.green_tripdata_partitoned4_clustered4
CLUSTER BY DATE(lpep_pickup_datetime), PUlocationID AS
SELECT * FROM data-engineering-project2023.ny_taxi.external_green_tripdata;