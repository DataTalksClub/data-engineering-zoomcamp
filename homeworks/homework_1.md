# Module 1 Homework: Docker & SQL


## Question 1. Understanding docker first run 

Run on local machine:
```bash
docker run -it python:3.12.8 bash
```

Run in docker bash:
```bash
pip --version
```

It outputs `pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)`.


## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, what is the `hostname` and `port` that **pgadmin** should use to connect to the postgres database?

```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```

Answer: since both those images will be running in docker-compose, the name for database is equal to its name in docker-compose, i.e. `db`. Also, the port forwarding is set and it maps `5433` to `5432`, so we'll be able to reach the database at `db:5432`. Actually, `postgres` is also possible, because the container is running under that name.


##  Prepare Postgres

In order to upload the data to Postgres, we'll need several containers and scripts:

1. Dockerfile:

```
FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY homework_1_ingest_data.py homework_1_ingest_data.py

ENTRYPOINT [ "python", "homework_1_ingest_data.py" ]
```

2. Script to ingest data, it's called `homework_1_ingest_data.py`, in this directory.

3. Build the container: `docker build . -t taxi_ingest:v001`

4. Start the docker container with database:

```
docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network \
    --name pg-database \
    postgres:13
```

5. Run the container that actually ingests the data and wait for the process to finish:

```
docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
  --user=root \
  --password=root \
  --host=pg-database \
  --port=5432 \
  --db=ny_taxi \
  --green_taxi_table_name=green_taxi_data \
  --green_taxi_url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-10.csv.gz \
  --zones_table_name=taxi_zone_lookup \
  --zones_url=https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv
```

6. Run pgadmin container to have a user interface:

```
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```

Login there using pgadmin credentials, and register a new server with any name, `pg-database` as a hostname, `5432` as port, `root` as user and password. Now it would be possible to reach the data using pgadmin.


## Question 3. Trip Segmentation Count

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, **respectively**, happened:
1. Up to 1 mile
2. In between 1 (exclusive) and 3 miles (inclusive),
3. In between 3 (exclusive) and 7 miles (inclusive),
4. In between 7 (exclusive) and 10 miles (inclusive),
5. Over 10 miles 


The query set is:

1. Up to 1 mile: 104802
```sql
SELECT COUNT(*)
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance <= 1;
```

2. In between 1 (exclusive) and 3 miles (inclusive): 198924
```sql
SELECT COUNT(*)
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 1 AND trip_distance <= 3;
```

3. In between 3 (exclusive) and 7 miles (inclusive): 109603
```sql
SELECT COUNT(*)
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 3 AND trip_distance <= 7;
```

4. In between 7 (exclusive) and 10 miles (inclusive): 27678
```sql
SELECT COUNT(*)
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 7 AND trip_distance <= 10;
```

5. Over 10 miles: 35189
```sql
SELECT COUNT(*)
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01'
  AND lpep_dropoff_datetime < '2019-11-01'
  AND trip_distance > 10;
```


## Question 4. Longest trip for each day

Which was the pick up day with the longest trip distance?
Use the pick up time for your calculations.

```sql
SELECT lpep_pickup_datetime, trip_distance
FROM public.green_taxi_data
ORDER BY trip_distance DESC
LIMIT 5;
```

The answer is Oct 31, 2019.


## Question 5. Three biggest pickup zones

Which were the top pickup locations with over 13,000 in
`total_amount` (across all trips) for 2019-10-18?

Consider only `lpep_pickup_datetime` when filtering by date.
```sql
SELECT zl.zone,
  SUM(g.fare_amount) as total_amount
FROM public.green_taxi_data g
JOIN public.taxi_zone_lookup zl ON g.pulocationid = zl.locationid
WHERE DATE(g.lpep_pickup_datetime) = '2019-10-18'
GROUP BY zl.zone
HAVING SUM(g.total_amount) > 13000
ORDER BY total_amount DESC
LIMIT 3;
```

So the answer is `East Harlem North, East Harlem South, Morningside Heights`.


## Question 6. Largest tip

For the passengers picked up in October 2019 in the zone
name "East Harlem North" which was the drop off zone that had
the largest tip?

```sql
SELECT DISTINCT zlo.zone as dropoff_zone, tip_amount
FROM public.green_taxi_data g
JOIN public.taxi_zone_lookup zl 
  ON g.pulocationid = zl.locationid
JOIN public.taxi_zone_lookup zlo 
  ON g.dolocationid = zlo.locationid
WHERE DATE_TRUNC('month', lpep_pickup_datetime) = '2019-10-01'
  AND zl.zone = 'East Harlem North'
ORDER BY tip_amount DESC
LIMIT 1;
```

The answer is  `JFK Airport .


## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. 
Copy the files from the course repo
[here](../../../01-docker-terraform/1_terraform_gcp/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.


## Question 7. Terraform Workflow

Which of the following sequences, **respectively**, describes the workflow for: 
1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform`

The correct answer is `terraform init, terraform apply -auto-approve, terraform destroy`.


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw1
