## Loading fhv data - 2019

1. used 03-data-warehouse/extras/web_to_gcs.py to download and upload PARQUET file to GCS
2. created an external table with all PARQUET file
> NOTE: the problem is that two of the PARQUET files have different column types compared to others. So converting the column types before saving to PARQUET files. 

3. created a partitioned table on pickup date, named as **fhv_tripdata** in BigQuery

```SQL
CREATE OR REPLACE EXTERNAL TABLE `robotic-incline-449301-g8.zoomcamp.external_fhv_tripdata`
(
  dispatching_base_num STRING, 
  pickup_datetime STRING, 
  dropOff_datetime STRING, 
  PUlocationID FLOAT64, 
  DOlocationID FLOAT64, 
  SR_Flag FLOAT64, 
  Affiliated_base_number STRING 
)
OPTIONS (
  format = 'PARQUET',
  uris = ['gs://dezoomcamp_hw3_202502/fhv/fhv_tripdata_2019-*.parquet']);


SELECT * FROM `robotic-incline-449301-g8.zoomcamp.external_fhv_tripdata`;

CREATE OR REPLACE TABLE robotic-incline-449301-g8.zoomcamp.fhv_tripdata_nonpartitioned AS
SELECT 
dispatching_base_num, 
PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', pickup_datetime) AS pickup_datetime,
PARSE_TIMESTAMP('%Y-%m-%d %H:%M:%S', dropOff_datetime) AS dropOff_datetime,
PUlocationID, 
DOlocationID, 
SR_Flag, 
Affiliated_base_number
FROM robotic-incline-449301-g8.zoomcamp.external_fhv_tripdata;

-- Create a partitioned table from external table
CREATE OR REPLACE TABLE robotic-incline-449301-g8.zoomcamp.fhv_tripdata
PARTITION BY
  DATE(pickup_datetime) AS
SELECT * FROM robotic-incline-449301-g8.zoomcamp.fhv_tripdata_nonpartitioned;
```
