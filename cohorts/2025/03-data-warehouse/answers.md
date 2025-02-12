## Question 1

```
What is count of records for the 2024 Yellow Taxi Data?
```

Query:
SELECT COUNT(*) FROM `dataset.yellow_taxi_trip_data`

Answer: 
20,332,093

## Question 2

```
Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?
```

Queries: 
SELECT DISTINCT COUNT(PULocationID) FROM `dataset.external_yellow_taxi_trip_data`;

SELECT DISTINCT COUNT(PULocationID) FROM `dataset.yellow_taxi_trip_data`;

Answer: 
0 MB for the External Table and 155.12 MB for the Materialized Table

## Question 3

```
Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. 
Now write a query to retrieve the PULocationID and DOLocationID on the same table. 
Why are the estimated number of Bytes different?
```

Queries:
SELECT DISTINCT COUNT(PULocationID) FROM `dataset.external_yellow_taxi_trip_data`;

SELECT DISTINCT COUNT(PULocationID) FROM `dataset.yellow_taxi_trip_data`;

Answer: 
BigQuery is a columnar database, and it only scans the specific columns requested in the query. 
Querying two columns (PULocationID, DOLocationID) requires reading more data than querying one column (PULocationID), 
leading to a higher estimated number of bytes processed.

## Question 4

```
How many records have a fare_amount of 0?
```

Query:
SELECT COUNT(*) FROM `dataset.yellow_taxi_trip_data` WHERE fare_amount = 0;

Answer:
8,333

## Question 5

```
What is the best strategy to make an optimized table in Big Query if your query will always filter based on 
tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)
```

Query:
CREATE OR REPLACE TABLE `dataset.yellow_taxi_trip_data_partitioned_and_clustered` 
PARTITION BY DATE(tpep_pickup_datetime)
CLUSTER BY VendorID AS
SELECT * FROM `dataset.yellow_taxi_trip_data` ;

Answer:
Partition by tpep_dropoff_datetime and Cluster on VendorID

## Question 6

```
Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)

Use the materialized table you created earlier in your from clause and note the estimated bytes. 
Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. 
What are these values?

Choose the answer which most closely matches.
```

Queries:
SELECT DISTINCT COUNT(VendorID) FROM `dataset.yellow_taxi_trip_data`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

SELECT DISTINCT COUNT(VendorID) FROM `dataset.yellow_taxi_trip_data_partitioned_and_clustered`
WHERE DATE(tpep_pickup_datetime) BETWEEN '2024-03-01' AND '2024-03-15';

Answer:
310.24 MB for non-partitioned table and 26.84 MB for the partitioned table

## Question 7

```
Where is the data stored in the External Table you created?
```

Answer:
GCP Bucket

## Question 8

```
It is best practice in Big Query to always cluster your data:
```

Answer:
False

## Question 9

```
Write a SELECT count(*) query FROM the materialized table you created. How many bytes does it estimate will be read? Why?
```

Query:
SELECT COUNT(*) FROM `dataset.yellow_taxi_trip_data`

Answer:
0b. Because the query is optimized with caching and the query was already run. 
There are also no incremental records since it was first run.
