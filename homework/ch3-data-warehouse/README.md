```
CREATE OR REPLACE EXTERNAL TABLE `dtc-de-course-486306.dataset.external_yellow_tripdata`
OPTIONS (
  format = 'PARQUET',
  uris = [
    'gs://yellow-taxi-2024/yellow_tripdata_2024-01.parquet',
    'gs://yellow-taxi-2024/yellow_tripdata_2024-02.parquet',
    'gs://yellow-taxi-2024/yellow_tripdata_2024-03.parquet',
    'gs://yellow-taxi-2024/yellow_tripdata_2024-04.parquet',
    'gs://yellow-taxi-2024/yellow_tripdata_2024-05.parquet',
    'gs://yellow-taxi-2024/yellow_tripdata_2024-06.parquet'
  ]
);

```

```
CREATE OR REPLACE TABLE `dtc-de-course-486306.dataset.yellow_tripdata_2024_not_partitioned`
AS
SELECT * FROM `dtc-de-course-486306.dataset.yellow_tripdata_2024_01`
UNION ALL
SELECT * FROM `dtc-de-course-486306.dataset.yellow_tripdata_2024_02`
UNION ALL
SELECT * FROM `dtc-de-course-486306.dataset.yellow_tripdata_2024_03`
UNION ALL
SELECT * FROM `dtc-de-course-486306.dataset.yellow_tripdata_2024_04`
UNION ALL
SELECT * FROM `dtc-de-course-486306.dataset.yellow_tripdata_2024_05`
UNION ALL
SELECT * FROM `dtc-de-course-486306.dataset.yellow_tripdata_2024_06`;
```