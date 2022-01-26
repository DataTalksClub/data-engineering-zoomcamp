# notes.md


### Gcloud CLI 
Check Gcloud Version:


```
gcloud --version
Google Cloud SDK 368.0.0
bq 2.0.72
core 2022.01.07
gsutil 5.6
```

Create a GCP Project:

<img width="325" alt="image" src="https://user-images.githubusercontent.com/9532712/150108868-54f249d2-1eb0-4476-b35f-309d6db18f9e.png">


### Terraform

`terraform plan`
```
                                                            main
var.project
  Your GCP Project ID

  Enter a value: dataeng-zoomcamp


Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.dataset will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "trips_data_all"
      + delete_contents_on_destroy = false
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "europe-west6"
      + project                    = "dataeng-zoomcamp"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }
    }

  # google_storage_bucket.data-lake-bucket will be created
  + resource "google_storage_bucket" "data-lake-bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "EUROPE-WEST6"
      + name                        = "dtc_data_lake_dataeng-zoomcamp"
      + project                     = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = true
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "Delete"
            }

          + condition {
              + age                   = 30
              + matches_storage_class = []
              + with_state            = (known after apply)
            }
        }

      + versioning {
          + enabled = true
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.
```

`terraform apply`

```
terraform apply                                                            main
var.project
  Your GCP Project ID

  Enter a value: dataeng-zoomcamp


Terraform used the selected providers to generate the following execution plan. Resource actions
are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.dataset will be created
  + resource "google_bigquery_dataset" "dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "trips_data_all"
      + delete_contents_on_destroy = false
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "europe-west6"
      + project                    = "dataeng-zoomcamp"
      + self_link                  = (known after apply)

      + access {
          + domain         = (known after apply)
          + group_by_email = (known after apply)
          + role           = (known after apply)
          + special_group  = (known after apply)
          + user_by_email  = (known after apply)

          + view {
              + dataset_id = (known after apply)
              + project_id = (known after apply)
              + table_id   = (known after apply)
            }
        }
    }

  # google_storage_bucket.data-lake-bucket will be created
  + resource "google_storage_bucket" "data-lake-bucket" {
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "EUROPE-WEST6"
      + name                        = "dtc_data_lake_dataeng-zoomcamp"
      + project                     = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + uniform_bucket_level_access = true
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "Delete"
            }

          + condition {
              + age                   = 30
              + matches_storage_class = []
              + with_state            = (known after apply)
            }
        }

      + versioning {
          + enabled = true
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.dataset: Creating...
google_storage_bucket.data-lake-bucket: Creating...
google_storage_bucket.data-lake-bucket: Creation complete after 2s [id=dtc_data_lake_dataeng-zoomcamp]
google_bigquery_dataset.dataset: Creation complete after 4s [id=projects/dataeng-zoomcamp/datasets/trips_data_all]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```


We run the docker compose command to spin up the postgres db and try to connect to pgadmin

Note that the host is the service name in the docker compose file.

in pgadmin UI settings:

```
Host: pgdatabase
Port: 5432
username: root
```


## Run the ingestion script with docker: 

Build the image

```bash
docker build -t taxi_ingest:v001 .
```

Run the script with Docker

The IP below is obtained after running `python -m http.server` and running `ifconfig -a` to obtain your local machine IP address

Docker compose creates a network automatically, check the network name by running `docker network ls`



```bash
URL="http://<your-ip>:8000/yellow_tripdata_2021-01.csv"

docker run -it \
  --network=2_docker_sql_default \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pgdatabase \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}
```


After running the ingestion script:

Logs of Ingestion Script:
```
HTTP request sent, awaiting response... 200 OK
Length: 125981363 (120M) [text/csv]
Saving to: ‘output.csv’

output.csv                 100%[========================================>] 120.14M  75.7MB/s    in 1.6s    

2022-01-26 10:22:06 (75.7 MB/s) - ‘output.csv’ saved [125981363/125981363]

inserted another chunk, took 13.161 second
inserted another chunk, took 13.234 second
inserted another chunk, took 12.488 second
...
StopIteration


```


We also need to load the zones table

```python

# Obtain the file 
!wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv


# load a new table like so
from sqlalchemy import create_engine
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
df_zones = pd.read_csv('taxi+_zone_lookup.csv')
df_zones.to_sql(name='zones', con=engine, if_exists='replace')
```

### SQL 


Some of the queries used:


Find the trips and add the name of the zones, show only the first 100 records


```sql
SELECT
    *
FROM
    yellow_taxi_trips t,
    zones zpu,
    zones zdo
WHERE
    t."PULocationID" = zpu."LocationID" AND
    t."DOLocationID" = zdo."LocationID"
LIMIT 100;
```


Extract the number of trips based on partial timestamp

```sql
SELECT count(*) FROM yellow_taxi_trips where DATE(tpep_pickup_datetime)='2021-01-15' limit 100;
```

Highest Tip by Day
```sql
SELECT date(tpep_pickup_datetime), tip_amount from yellow_taxi_trips ytt order by tip_amount DESC;
```

Num of Trips on a specific day by zone:
```sql
SELECT 
    zdo."Zone",
    count(*) 
FROM
    yellow_taxi_trips t,
    zones zdo
WHERE
    t."DOLocationID" = zdo."LocationID" AND
	date(t.tpep_pickup_datetime)  = '2021-01-14'  
GROUP BY zdo."Zone"
```

Highest avg amount by Zone
```sql
SELECT
    zpu."Zone"
 	, zdo."Zone"
 	, avg(total_amount)
FROM
    yellow_taxi_trips t,
    zones zpu,
    zones zdo
WHERE
    t."PULocationID" = zpu."LocationID" AND
    t."DOLocationID" = zdo."LocationID"
GROUP BY zpu."Zone"
 	, zdo."Zone"
ORDER BY avg(total_amount) DESC

```

Highest Avg Price by Zone Pairing:

```sql
SELECT
    zpu."Zone"
 	, zdo."Zone"
 	, avg(total_amount)
FROM
    yellow_taxi_trips t,
    zones zpu,
    zones zdo
WHERE
    t."PULocationID" = zpu."LocationID" AND
    t."DOLocationID" = zdo."LocationID"
GROUP BY zpu."Zone"
 	, zdo."Zone"
c avg(total_amount) DESC
LIMIT 100;
```