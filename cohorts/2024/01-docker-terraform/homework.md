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

Docs are quite straightforward here running `docker run --help` yields 

"--rm  Automatically remove the container when it exits"

## Question 2. Understanding docker first run 

Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash.
Now check the python modules that are installed ( use ```pip list``` ). 

What is version of the package *wheel* ?

- 0.42.0
- 1.0.0
- 23.0.1
- 58.1.0

root@9b1bddb68655:/# pip list
Package    Version

---

pip        23.0.1
setuptools 58.1.0
wheel      0.42.0

Answer is 0.42.0

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

```sql
select count(*) 
from green_taxi_data
where lpep_pickup_datetime >= '2019-09-18 00:00:00' 
and lpep_dropoff_datetime <= '2019-09-18 23:59:59'
```

yields 15612

## Question 4. Largest trip for each day

Which was the pick up day with the largest trip distance
Use the pick up time for your calculations.

- 2019-09-18
- 2019-09-16
- 2019-09-26
- 2019-09-21

```sql
select * from green_taxi_data order by trip_distance desc
```

2019-09-26 19:32:52 -  341.64

## Question 5. The number of passengers

Consider lpep_pickup_datetime in '2019-09-18' and ignoring Borough has Unknown

Which were the 3 pick up Boroughs that had a sum of total_amount superior to 50000?
 
- "Brooklyn" "Manhattan" "Queens"
- "Bronx" "Brooklyn" "Manhattan"
- "Bronx" "Manhattan" "Queens" 
- "Brooklyn" "Queens" "Staten Island"

```sql
select zones."Borough", sum(green_taxi_data.total_amount) as t  
from green_taxi_data 
inner join zones on green_taxi_data."PULocationID" = zones."LocationID"  where lpep_pickup_datetime >= '2019-09-18 00:00:00' and lpep_pickup_datetime <= '2019-09-18 23:59:59' 
group by 1 
order by t desc
```

| Borough       | t                  |
|---------------+--------------------|
| Brooklyn      | 96333.23999999915  |
| Manhattan     | 92271.2999999985   |
| Queens        | 78671.70999999918  |
| Bronx         | 32830.090000000055 |
| Unknown       | 728.75             |
| Staten Island | 342.59             |
+---------------+--------------------+


## Question 6. Largest tip

For the passengers picked up in September 2019 in the zone name Astoria which was the drop off zone that had the largest tip?
We want the name of the zone, not the id.

Note: it's not a typo, it's `tip` , not `trip`

- Central Park
- Jamaica
- JFK Airport
- Long Island City/Queens Plaza

```sql
with highest_tip_zone as (
select green_taxi_data."DOLocationID" as do,green_taxi_data.tip_amount
from green_taxi_data 
inner join zones on green_taxi_data."PULocationID" = zones."LocationID"  
where lpep_pickup_datetime >= '2019-09-01 00:00:00' and lpep_pickup_datetime <= '2019-09-30 23:59:59'  and zones."Zone" = 'Astoria' 
order by green_taxi_data.tip_amount desc 
limit 2
)

select z."Zone", tip_amount
from zones z
inner join highest_tip_zone htz on z."LocationID" = htz."do"
```

+-------------+------------+
| Zone        | tip_amount |
|-------------+------------|
| JFK Airport | 62.31      |
| Woodside    | 30.0       |
+-------------+------------+

## Terraform

In this section homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP/Laptop/GitHub Codespace install Terraform. 
Copy the files from the course repo
[here](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_1_basics_n_setup/1_terraform_gcp/terraform) to your VM/Laptop/GitHub Codespace.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.


## Question 7. Creating Resources

After updating the main.tf and variable.tf files run:

```
terraform apply
```

Paste the output of this command into the homework submission form.


## Submitting the solutions

* Form for submitting: 
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: