## Module 1 Homework

## Docker & SQL

In this homework we'll prepare the environment 
and practice with Docker and SQL


## Question 1. Knowing docker tags

Run the command to get information on Docker 

```docker --help```

Now run the command to get help on the "docker build" command:

```docker build --help```

Do the same for "docker run".

Which tag has the following text? - *Automatically remove the container when it exits* 

- `--delete`
- `--rc`
- `--rmc`
- `--rm`

**A:** docker run --help
--rm                             Automatically remove the container when it exits


## Question 2. Understanding docker first run 

Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash.
Now check the python modules that are installed ( use ```pip list``` ). 

What is version of the package *wheel* ?

- 0.42.0
- 1.0.0
- 23.0.1
- 58.1.0

**A:** 
wheel      0.42.0


# Prepare Postgres

Run Postgres and load data as shown in the videos
We'll use the green taxi trips from September 2019:

```wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz```

You will also need the dataset with zones:

```wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv```

Download this data and put it into Postgres (with jupyter notebooks or with a pipeline)


## Question 3. Count records 

How many taxi trips were totally made on September 18th 2019?

Tip: started and finished on 2019-09-18. 

Remember that `lpep_pickup_datetime` and `lpep_dropoff_datetime` columns are in the format timestamp (date and hour+min+sec) and not in date.

- 15767
- 15612
- 15859
- 89009

**A:**
- 15612
sql: SELECT COUNT(*) FROM green_taxi_trip WHERE lpep_pickup_datetime >= '2019-09-18' AND lpep_dropoff_datetime < '2019-09-19';

## Question 4. Largest trip for each day

Which was the pick up day with the largest trip distance
Use the pick up time for your calculations.

- 2019-09-18
- 2019-09-16
- 2019-09-26
- 2019-09-21

**A:**
2019-09-26

sql: 
```sql
SELECT CAST(lpep_pickup_datetime AS DATE) as date, SUM(trip_distance) as trip_sum FROM green_taxi_trip GROUP BY date ORDER BY trip_sum DESC;
```
This will sum the trip distance by date and list the largest trip distance date at the top


## Question 5. Three biggest pick up Boroughs

Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown

Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?
 
- "Brooklyn" "Manhattan" "Queens"
- "Bronx" "Brooklyn" "Manhattan"
- "Bronx" "Manhattan" "Queens" 
- "Brooklyn" "Queens" "Staten Island"

**A:**
- "Brooklyn" "Manhattan" "Queens"

sql: 
```sql
SELECT "Borough", SUM(total_amount) as total FROM 
( 
	SELECT gtt."PULocationID", tzl."Borough", gtt.total_amount FROM green_taxi_trip gtt
	LEFT JOIN taxi_zone_lookup tzl ON gtt."PULocationID" = tzl."LocationID" WHERE gtt.lpep_pickup_datetime >= '2019-09-18' AND gtt.lpep_pickup_datetime < '2019-09-19'
) AS tb
GROUP BY "Borough" ORDER BY total DESC;
```


## Question 6. Largest tip

For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip?
We want the name of the zone, not the id.

Note: it's not a typo, it's `tip` , not `trip`

- Central Park
- Jamaica
- JFK Airport
- Long Island City/Queens Plaza

**A:**
- Long Island City/Queens Plaza

sql: 
```sql
SELECT SUM(tip_amount) AS total_tip,  d_zone FROM
(
	SELECT gtt.tip_amount, pz."Zone" as p_zone, gtt."DOLocationID", dz."Zone" as d_zone FROM green_taxi_trip gtt
	LEFT JOIN taxi_zone_lookup pz ON gtt."PULocationID" = pz."LocationID" 
	LEFT JOIN taxi_zone_lookup dz ON gtt."DOLocationID" = dz."LocationID"
	WHERE gtt.lpep_pickup_datetime >= '2019-09-01' AND gtt.lpep_pickup_datetime < '2019-10-01' AND pz."Zone"='Astoria' AND dz."Zone" in ('Central Park','Jamaica', 'JFK Airport', 'Long Island City/Queens Plaza')
) as tb
GROUP BY d_zone ORDER BY total_tip DESC;
```


## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. 
Copy the files from the course repo
[here](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/01-docker-terraform/1_terraform_gcp/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.


## Question 7. Creating Resources

After updating the main.tf and variable.tf files run:

```
terraform apply
```

Paste the output of this command into the homework submission form.

```bash
google_bigquery_dataset.demo_dataset: Refreshing state... [id=projects/datatalk-de/datasets/demo_dataset]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US"
      + name                        = "terraform-demo-terra-bucket"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_storage_bucket.demo-bucket: Creating...
╷
│ Error: googleapi: Error 409: The requested bucket name is not available. The bucket namespace is shared by all users of the system. Please select a different name and try again., conflict
│ 
│   with google_storage_bucket.demo-bucket,
│   on main.tf line 17, in resource "google_storage_bucket" "demo-bucket":
│   17: resource "google_storage_bucket" "demo-bucket" {
│ 
```


## Submitting the solutions

* Form for submitting: https://courses.datatalks.club/de-zoomcamp-2024/homework/hw01
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 29 January, 23:00 CET
