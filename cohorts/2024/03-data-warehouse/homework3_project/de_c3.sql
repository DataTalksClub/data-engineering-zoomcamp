-- Create external table from parquets
CREATE OR REPLACE EXTERNAL TABLE `datatalk-de.ny_taxi.external_greentaxi_2022_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://datatalk-de-homework3-hy1/green_tripdata_2022-*.parquet']
);

-- Create matrialized table from external table
CREATE OR REPLACE TABLE datatalk-de.ny_taxi.greentaxi_2022_tripdata_non_partitioned AS
SELECT * FROM datatalk-de.ny_taxi.external_greentaxi_2022_tripdata;

-- The total count of records
SELECT COUNT(*) FROM datatalk-de.ny_taxi.external_greentaxi_2022_tripdata;

-- The count of distinct PULocationID run on external table and matrialized table
SELECT COUNT(DISTINCT PULocationID) FROM datatalk-de.ny_taxi.external_greentaxi_2022_tripdata;
SELECT COUNT(DISTINCT PULocationID) FROM datatalk-de.ny_taxi.greentaxi_2022_tripdata_non_partitioned;

-- The count of records that fare_amount is 0
SELECT COUNT(*) FROM datatalk-de.ny_taxi.external_greentaxi_2022_tripdata WHERE fare_amount=0;