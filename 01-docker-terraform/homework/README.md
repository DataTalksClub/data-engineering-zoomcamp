# Module 1 Homework: Docker & SQL
In this homework we'll prepare the environment and practice Docker and SQL

## Question 1. Understanding docker first run
Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint bash.

The version of `pip` in the image is: `24.3.1`


## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, **pgadmin** should use the following to connect to the postgres database:
- hostname: db
    - use the `service name` for hostname
    - **correction:** both the `service name` and the `container name` can be used for **pgadmin** to connect to the database
- port: 5432 
    - the ports mapping (5433:5432) only affects connections from **outside Docker** (e.g., from your host machine). Inside the Docker network, pgAdmin connects to Postgres on port 5432.


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

## Question 3. Trip Segmentation Count

Answer: `104,802; 198,924; 109,603; 27,678; 35,189`

Code: 

```sql
SELECT 
	CASE
		WHEN trip_distance <= 1 THEN 'Up to 1 mile'
		WHEN trip_distance > 1 AND trip_distance <=3 THEN '1-3 miles'
		WHEN trip_distance > 3 AND trip_distance <= 7 THEN '3-7 miles'
		WHEN trip_distance > 7 AND trip_distance <= 10 THEN '7-10 miles'
		ELSE 'Over 10 miles'
	END AS Category,
	COUNT(*) AS Cnt
FROM 
	green_taxi_trips
WHERE 
	lpep_pickup_datetime >= '2019-10-01'
	AND lpep_pickup_datetime < '2019-11-01'
	AND lpep_dropoff_datetime >= '2019-10-01'
	AND lpep_dropoff_datetime < '2019-11-01'
GROUP BY Category
ORDER BY 1
```
## Question 4. Longest trip for each day

Answer:`2019-10-31`

Code:

```sql
SELECT lpep_pickup_datetime
FROM green_taxi_trips
WHERE trip_distance =
	(SELECT 
		MAX(trip_distance)
	FROM green_taxi_trips)
```
 or

 ```sql
 SELECT
	lpep_pickup_datetime,
	MAX(trip_distance) as max_distance
FROM green_taxi_trips
GROUP BY lpep_pickup_datetime
ORDER BY max_distance DESC
LIMIT 1
 ```

## Question 5. Three biggest pickup zones

Answer: `East Harlem North, East Harlem South, Morningside Heights`

Code:

 ```sql
 SELECT
	z."Zone" AS zone,
	SUM(g.total_amount) AS total_amount
FROM 
	green_taxi_trips g
	INNER JOIN taxi_zone_lookup z
		ON z."LocationID" = g."PULocationID"
WHERE CAST(g.lpep_pickup_datetime AS date)= '2019-10-18'
GROUP BY z."Zone"
ORDER BY 2 DESC
LIMIT 3
```

## Question 6. Largest tip

Answer: `JFK Airport`

Code:

```sql
SELECT
	zd."Zone" AS DropOffZone,
	max(g.tip_amount) AS MaxTip
FROM 
	green_taxi_trips g
	INNER JOIN taxi_zone_lookup zd
		ON zd."LocationID" = g."DOLocationID"
	INNER JOIN taxi_zone_lookup zp
		ON zp."LocationID" = g."PULocationID"
WHERE
	zp."Zone" = 'East Harlem North'
	AND EXTRACT(MONTH FROM CAST(g.lpep_pickup_datetime AS date)) = 10
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
```

## Question 7. Terraform Workflow

Answer: `terraform init, terraform apply -auto-approve, terraform destroy`