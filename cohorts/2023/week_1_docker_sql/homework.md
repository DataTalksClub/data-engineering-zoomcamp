## Week 1 Homework

In this homework we'll prepare the environment 
and practice with Docker and SQL


## Question 1. Knowing docker tags

Run the command to get information on Docker 

```docker --help```

Now run the command to get help on the "docker build" command

Which tag has the following text? - *Write the image ID to the file* 

- `--imageid string`
- `--iidfile string`
- `--idimage string`
- `--idfile string`

### Answer: 

- `--iidfile string`

## Question 2. Understanding docker first run 

Run docker with the python:3.9 image in an interactive mode and the entrypoint of bash.
Now check the python modules that are installed ( use pip list). 
How many python packages/modules are installed?

- 1
- 6
- 3
- 7

### Answer: 

There are three packages installed. pip, setuptools and wheel - these are required to build other packages.

# Prepare Postgres

Run Postgres and load data as shown in the videos
We'll use the green taxi trips from January 2019:

```wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz```

You will also need the dataset with zones:

```wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv```

Download this data and put it into Postgres (with jupyter notebooks or with a pipeline)


### Answer

1. Loading the zones data

Add trivial if statement for tpep colums to ingest_data:

```{python}
if 'tpep_pickup_datetime' in df.columns.to_list():
    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
```
and for the new date columns in the green taxi data:

```{python}
if 'lpep_pickup_datetime' in df.columns.to_list():
    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
```

Then rebuild 

```{bash}
docker build -t taxi_ingest:v002 .
```

```{bash}
URL="https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv"
docker run -it --network=pg-network taxi_ingest:v002 \
      --user=root \
      --password=root \
      --host=pg-database \
      --port=5432 \
      --db=ny_taxi \
      --table_name=zones \
      --url=${URL}
```

2. 
```{bash}
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-01.csv.gz"
docker run -it --network=pg-network taxi_ingest:v002 \
      --user=root \
      --password=root \
      --host=pg-database \
      --port=5432 \
      --db=ny_taxi \
      --table_name=green_trip_data \
      --url=${URL}
```


## Question 3. Count records 

How many taxi trips were totally made on January 15?

Tip: started and finished on 2019-01-15. 

Remember that `lpep_pickup_datetime` and `lpep_dropoff_datetime` columns are in the format timestamp (date and hour+min+sec) and not in date.

- 20689
- 20530
- 17630
- 21090

### Answer

```{sql}
SELECT count(*) 
FROM green_trip_data 
WHERE lpep_pickup_datetime => '2019-01-15' 
  AND lpep_dropoff_datetime < '2019-01-16'
```

There were 20530 trips started and completed on 2019-01-15.

## Question 4. Largest trip for each day

Which was the day with the largest trip distance
Use the pick up time for your calculations.

- 2019-01-18
- 2019-01-28
- 2019-01-15
- 2019-01-10

```{sql}
SELECT max(trip_distance), TO_CHAR(lpep_pickup_datetime, 'YYYY-MM-DD') AS pickup_date 
FROM green_trip_data
WHERE lpep_pickup_datetime > '2019-01-10' AND lpep_pickup_datetime < '2019-01-28'
GROUP BY "pickup_date"
ORDER BY "pickup_date" ASC;
```

The largest trip distance occured on 2019-01-15 with a distance of 117.99 miles.


## Question 5. The number of passengers

In 2019-01-01 how many trips had 2 and 3 passengers?
 
- 2: 1282 ; 3: 266
- 2: 1532 ; 3: 126
- 2: 1282 ; 3: 254
- 2: 1282 ; 3: 274

### Answer

```{sql}
SELECT count(*), passenger_count
FROM green_trips_data
WHERE lpep_pickup_datetime BETWEEN '2019-01-01' AND '2019-01-02'
GROUP BY passenger_count
```

- 2: 1282 ; 3: 254

## Question 6. Largest tip

For the passengers picked up in the Astoria Zone which was the drop off zone that had the largest tip?
We want the name of the zone, not the id.

Note: it's not a typo, it's `tip` , not `trip`

- Central Park
- Jamaica
- South Ozone Park
- Long Island City/Queens Plaza

### Answer 

```{sql}
SELECT tip_amount, g."PULocationID", g."DOLocationID", z."Zone", z."Borough", z."service_zone"
FROM green_trip_data as g
INNER JOIN zones as z ON g."DOLocationID" = z."LocationID"
WHERE g."PULocationID" = 7 -- Astoria LocationID = 7
ORDER BY tip_amount DESC;
```

The highest tip was $88 and the dropoff location was Long Island City/Queens Plaza

## Submitting the solutions

* Form for submitting: [form](https://forms.gle/EjphSkR1b3nsdojv7)
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 26 January (Thursday), 22:00 CET


## Solution

We will publish the solution here
