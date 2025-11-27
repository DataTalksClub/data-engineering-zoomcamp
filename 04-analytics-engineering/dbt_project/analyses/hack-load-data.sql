CREATE TABLE IF NOT EXISTS taxi_rides_ny.raw.green_tripdata AS (
  SELECT * FROM read_parquet([
    'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-*.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2024-*.parquet'
  ])
);

CREATE TABLE IF NOT EXISTS taxi_rides_ny.raw.yellow_tripdata AS (
  SELECT * FROM read_parquet([
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2023-*.parquet',
    'https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-*.parquet'
  ])
);
