#!/usr/bin/env bash

## bash script to run the ingestion container
echo "Running data ingestion for January 2021..."

docker run -it --rm \
  --network=pg-network \
  taxi_ingest:v001 \
  --year=2021 \
  --month=1 \
  --pg_user=root \
  --pg_password=root \
  --pg_host=pgdatabase \
  --pg_port=5432 \
  --pg_db=ny_taxi \
  --chunk_size=100000 \
  --target_table=yellow_taxi_trips