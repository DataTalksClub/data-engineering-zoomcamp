CREATE OR REPLACE EXTERNAL TABLE `dtc-de-375315.trips_data_all.fhv`
OPTIONS (
  format = 'CSV',
  uris = [
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-01.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-02.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-03.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-04.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-05.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-06.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-07.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-08.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-09.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-10.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-11.csv.gz', 
    'gs://dtc_data_lake_dtc-de-375315/data/fhv/fhv_tripdata_2019-12.csv.gz'
  ]
);

CREATE OR REPLACE TABLE dtc-de-375315.trips_data_all.fhv_bq AS
SELECT * FROM dtc-de-375315.trips_data_all.fhv;

SELECT COUNT(Affiliated_base_number) FROM dtc-de-375315.trips_data_all.fhv_bq;

SELECT DISTINCT Affiliated_base_number FROM dtc-de-375315.trips_data_all.fhv;

SELECT DISTINCT Affiliated_base_number FROM dtc-de-375315.trips_data_all.fhv_bq;

SELECT DISTINCT Affiliated_base_number FROM dtc-de-375315.trips_data_all.fhv;

SELECT DISTINCT Affiliated_base_number FROM dtc-de-375315.trips_data_all.fhv_bq;

SELECT DISTINCT COUNT(*) FROM dtc-de-375315.trips_data_all.fhv_bq WHERE (PUlocationID IS NULL) AND (DOlocationID IS NULL);

CREATE OR REPLACE TABLE dtc-de-375315.trips_data_all.fhv_pnc
PARTITION BY DATE(pickup_datetime)
CLUSTER BY Affiliated_base_number AS
SELECT * FROM dtc-de-375315.trips_data_all.fhv_bq;

SELECT DISTINCT Affiliated_base_number FROM dtc-de-375315.trips_data_all.fhv_pnc 
WHERE pickup_datetime BETWEEN '2019-03-01 00:00:00' AND '2019-03-31 00:00:00';



-- 1 - 43,244,696
-- 2 - 0 MB for the External Table and 317.94MB for the BQ Table
-- 3 - 717748
-- 4 - Partition by pickup_datetime Cluster on affiliated_base_number
-- 5 - 647.87 MB for non-partitioned table and 23.06 MB for the partitioned table
-- 6 - GCP Bucket
-- 7 - False
-- 8 - 