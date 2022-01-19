## Docker and SQL

Notes I used for preparing the videos: [link](https://docs.google.com/document/d/e/2PACX-1vRJUuGfzgIdbkalPgg2nQ884CnZkCg314T_OBq-_hfcowPxNIA0-z5OtMTDzuzute9VBHMjNYZFTCc1/pub)


## Commands 

All the commands from the video

Downloading the data

```bash
wget https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv
```

### Running Postgres with Docker

#### Windows

Running postgres on windows (note the full path)

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v c:/Users/alexe/git/data-engineering-zoomcamp/week_1_basics_n_setup/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13
```

If you have the following error:

```
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v e:/zoomcamp/data_engineer/week_1_fundamentals/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/data  \
  -p 5432:5432 \
  postgres:13

docker: Error response from daemon: invalid mode: \Program Files\Git\var\lib\postgresql\data.
See 'docker run --help'.
```

Change the mouning path. Replace it with the following:

```
-p /e/zoomcamp/...:/var/lib/postgresql/data
```

#### Linux and MacOS


```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  postgres:13
```

If you see that `ny_taxi_postgres_data` is empty after running
the container, try these:

* Deleting the folder and running Docker again (Docker will re-create the folder)
* Adjust the permissions of the folder by running `sudo chmod  a+rwx ny_taxi_postgres_data`


### CLI for Postgres

Installing pgcli

```bash
pip install pgcli
```

If you have problems installing pgcli with the command above, try this:

```bash
conda install -c conda-forge pgcli
pip install -U mycli
```

Using pgcli to connect to postgres

```bash
pgcli -h localhost -p 5432 -u root -d ny_taxi
```

Dataset:

* https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page
* https://www1.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf


Running pgAdmin

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  dpage/pgadmin4
```

### Running Postgres and pgAdmin together

Create a network

```bash
docker network create pg-network
```

Run Postgres (change the path)

```bash
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v c:/Users/alexe/git/data-engineering-zoomcamp/week_1_basics_n_setup/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
```

Run pgAdmin

```bash
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin-2 \
  dpage/pgadmin4
```


### Data ingestion

Running locally

```bash
URL="https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2021-01.csv"

python ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}
```

Build the image

```bash
docker build -t taxi_ingest:v001 .
```

Run the script with Docker

```bash
URL="http://172.24.208.1:8000/yellow_tripdata_2021-01.csv"

docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
```

### Docker-Compose 

Run it:

```bash
docker-compose up
```

Run in detached mode:

```bash
docker-compose up -d
```

Shutting it down:

```bash
docker-compose down
```


### SQL 

Coming soon!
