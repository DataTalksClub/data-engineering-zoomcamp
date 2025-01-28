# Module 1 Homework: Docker & SQL

Shell commands or SQL queries necessary for answering the questions.


## Question 1. Understanding docker first run

Commands:

```bash
docker run --rm -it --entrypoint=bash python:3.12.8
# inside the container:
pip --version
```

Output:

```plaintext
pip 24.3.1 from /usr/local/lib/python3.12/site-packages/pip (python 3.12)
```


## Question 3. Trip Segmentation Count

Query:
```sql
SELECT count(*) AS Total_Trips,
	CASE WHEN trip_distance <= 1.0 THEN 'Up_To_1_Mile'
		WHEN trip_distance > 1.0 AND trip_distance <= 3.0 THEN 'Between_1_and_3'
		WHEN trip_distance > 3.0 AND trip_distance <= 7.0 THEN 'Between_3_and_7'
		WHEN trip_distance > 7.0 AND trip_distance <= 10.0 THEN 'Between_7_and_10'
		WHEN trip_distance > 10.0 THEN 'Over_10_Miles' END AS Distance
FROM public.trips
    WHERE CAST(lpep_pickup_datetime AS DATE) >= '2019-10-01'::date and CAST(lpep_dropoff_datetime AS DATE) < '2019-11-01'::date
    GROUP BY Distance
```

Data output:

| Up_To_1_Mile | Between_1_and_3 | Between_3_and_7 | Between_7_and_10 | Over_10_Miles |
|--------------|-----------------|-----------------|------------------|---------------|
| 104802       | 198924          | 109603          | 27678            | 35189         |


## Question 4. Longest trip for each day

Query:

```sql
SELECT DISTINCT 
    MAX(trip_distance) AS MaxTripDistance,
    lpep_pickup_datetime::date
FROM 
    trips
GROUP BY
    lpep_pickup_datetime
ORDER BY 
    MaxTripDistance DESC
LIMIT 1;
```

Data output:

| date |
|------|
| 2019-10-31 |


## Question 5. Three biggest pickup zones

Query:

```sql
SELECT
    zl."Zone" as pickup_zone,
    SUM(total_amount) as total_amount
FROM trips t
    JOIN zones zl ON t."PULocationID" = zl."LocationID"
WHERE DATE(lpep_pickup_datetime) = '2019-10-18'
    GROUP BY zl."Zone"
    HAVING SUM(total_amount) > 13000
    ORDER BY total_amount DESC;
```

Data output:

| Zone |
|------|
| East Harlem North |
| East Harlem South |
| Morningside Heights |

## Question 6. Largest tip

Query:

```sql
SELECT
    zl_dropoff."Zone" as dropoff_zone,
    MAX(tip_amount) as largest_tip
FROM trips t
    JOIN zones zl_pickup ON t."PULocationID" = zl_pickup."LocationID"
    JOIN zones zl_dropoff ON t."DOLocationID" = zl_dropoff."LocationID"
WHERE zl_pickup."Zone" = 'East Harlem North'
    AND DATE_TRUNC('month', lpep_pickup_datetime) = '2019-10-01'
    GROUP BY zl_dropoff."Zone"
    ORDER BY largest_tip DESC
    LIMIT 1;

```

Data output:

| Zone |
|------|
| JFK Airport |


## Question 7
Which of the following sequences, respectively, describes the workflow for:

* Downloading the provider plugins and setting up backend,
* Generating proposed changes and auto-executing the plan
* Remove all resources managed by terraform`


Result: terraform init, terraform apply -auto-approve, terraform destroy
