CREATE OR REPLACE EXTERNAL TABLE
  `chromatic-timer-389403.nytaxi.fhv_tripdata_external` OPTIONS ( format = 'CSV',
    uris = ['gs://ride-duration_de-zoomcamp_chromatic-timer-389403/fhv/*.gz'] );

CREATE OR REPLACE TABLE
  `chromatic-timer-389403.nytaxi.fhv_tripdata_materialized` AS(
  SELECT
    *
  FROM
    `chromatic-timer-389403.nytaxi.fhv_tripdata_external`);

SELECT
  COUNT(*)
FROM
  `chromatic-timer-389403.nytaxi.fhv_tripdata_materialized`;

SELECT
  COUNT(DISTINCT(affiliated_base_number))
FROM
  `chromatic-timer-389403.nytaxi.fhv_tripdata_materialized`;

SELECT
  COUNT(*)
FROM
  `chromatic-timer-389403.nytaxi.fhv_tripdata_materialized`
WHERE
  DOlocationID IS NULL
  AND PUlocationID IS NULL;

CREATE OR REPLACE TABLE
  `chromatic-timer-389403.nytaxi.fhv_tripdata_partitioned`
PARTITION BY
  DATE(pickup_datetime)
CLUSTER BY
  affiliated_base_number AS (
  SELECT
    *
  FROM
    `chromatic-timer-389403.nytaxi.fhv_tripdata_external` );

SELECT
  DISTINCT affiliated_base_number
FROM
  `chromatic-timer-389403.nytaxi.fhv_tripdata_materialized`
WHERE
  DATE(pickup_datetime) BETWEEN '2019-03-01'
  AND '2019-03-31';

SELECT
  DISTINCT affiliated_base_number
FROM
  `chromatic-timer-389403.nytaxi.fhv_tripdata_partitioned`
WHERE
  DATE(pickup_datetime) BETWEEN '2019-03-01'
  AND '2019-03-31';