#!/usr/bin/env bash

## bash script to start the Postgres container
mkdir -p ../ny_taxi_postgres_data

echo "Starting PostgreSQL container..."

docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ../ny_taxi_postgres_data:/var/lib/postgresql \
  -p 5432:5432 \
  --network=pg-network \
  --name pgdatabase \
  postgres:18

# to use the pgcli
# pgcli -h localhost -p 5432 -u root -d ny_taxi