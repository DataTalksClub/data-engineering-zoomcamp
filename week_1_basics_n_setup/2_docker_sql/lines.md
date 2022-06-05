docker build -t taxi_ingest:v001 .


URL = "https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.parquet"

docker run -it \
    --network=2_docker_sql_default\
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pgdatabase \
        --port=5432 \
        --db=ny_taxi\
        --table_name=yellow_taxi_trips\
        --url="https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.parquet"

    