## Question 1. Understanding docker first run
```bash
docker run -it --entrypoint bash python:3.12.8
```

```bash
pip --version
```

Answer: <mark>24.3.1</mark>

### Question 2. Understanding Docker networking and docker-compose

Answer: <mark> db:5432 </mark>

## Question 3. Trip Segmentation Count

Answer: <mark>104,793; 198,924; 109,603; 27,678; 35,189</mark> 
```sql
SELECT
    COUNT(CASE WHEN trip_distance <= 1.0 THEN 1 END) AS up_to_1_mile,
    COUNT(CASE WHEN trip_distance > 1.0 AND trip_distance <= 3.0 THEN 1 END) AS between_1_and_3_miles,
    COUNT(CASE WHEN trip_distance > 3.0 AND trip_distance <= 7.0 THEN 1 END) AS between_3_and_7_miles,
    COUNT(CASE WHEN trip_distance > 7.0 AND trip_distance <= 10.0 THEN 1 END) AS between_7_and_10_miles,
    COUNT(CASE WHEN trip_distance > 10.0 THEN 1 END) AS over_10_miles
FROM
    green_taxi_data
WHERE
    date(lpep_pickup_datetime) >= '2019-10-01' AND
    date(lpep_pickup_datetime) < '2019-11-01' AND
    date(lpep_dropoff_datetime) >= '2019-10-01' AND
    date(lpep_dropoff_datetime) < '2019-11-01';
```

## Question 4. Longest trip for each day
Which was the pick up day with the longest trip distance? Use the pick up time for your calculations.

Answer: <mark>2019-10-31</mark>

```sql
SELECT
	EXTRACT( DAY FROM LPEP_PICKUP_DATETIME) AS DAY,
	MAX(TRIP_DISTANCE) AS LONGEST_TRIP_DISTANCE
FROM
	PUBLIC.GREEN_TAXI_DATA
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	1;
```

## Question 5. Three biggest pickup zones
Which where the top pickup locations with over 13,000 in total_amount (across all trips) for 2019-10-18?

Consider only lpep_pickup_datetime when filtering by date.

Answer: <mark>Morningside Heights,East Harlem South,East Harlem North </mark>
```sql
SELECT
	"Zone" AS pickup_location,
	SUM(total_amount)
FROM
	green_taxi_data G
	join zones Z ON G."PULocationID" = Z."LocationID"
WHERE
	DATE (LPEP_PICKUP_DATETIME) = '2019-10-18'
GROUP BY
	"Zone"
HAVING
	SUM(total_amount) > 13000
ORDER BY 2;
```
## Question 6. Largest tip
For the passengers picked up in Ocrober 2019 in the zone name "East Harlem North" which was the drop off zone that had the largest tip?

Answer: <mark>JFK Airport</mark>

```sql
SELECT
	DZ."Zone" AS DROPOFF_LOCATION,
	MAX(G.TIP_AMOUNT) AS LARGEST_TIP
FROM
	green_taxi_data G
	JOIN zones PZ ON G."PULocationID" = PZ."LocationID"
	JOIN zones DZ ON G."DOLocationID" = DZ."LocationID"
WHERE
	PZ."Zone" = 'East Harlem North'
	AND EXTRACT(YEAR FROM LPEP_PICKUP_DATETIME) = 2019
	AND EXTRACT(MONTH FROM LPEP_PICKUP_DATETIME) = 10
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT 1;
```

## Question 7. Terraform Workflow
Which of the following sequences, respectively, describes the workflow for:

1. Downloading the provider plugins and setting up backend,
2. Generating proposed changes and auto-executing the plan
3. Remove all resources managed by terraform

Answer: <mark> terraform init, terraform apply -auto-approve, terraform destroy </mark>