## Question 1. Knowing docker tags
```
❯ docker run --help | grep "Automatically remove"
--rm                               Automatically remove
```

- `|` pipe operator redirects the previous command output as an input to the command after the operator
- `docker run --help` -----> outputs `|` ---------> inputs to `grep "Automatically remove"`
- `grep` allows you to search through text
  
Answer: `--rm`


## Question 2. Understanding docker first run

- Run python:3.9 image with `docker run -it python:3.9 bash`
- Since you opened with `it` tag, the container will be interactive`
- Since the docker command ends with `bash`, the entrypoint into the container will be `bash`

```shell
root@root: docker run -it python:3.9 bash
root@b67c6949422a:/# pip list
Package    Version
---------- -------
pip        23.0.1
setuptools 58.1.0
wheel      0.45.1
```

Since it's been a while since 2024 cohort, your wheel version might differ and may not be in the options provided.

Answer: For me it was `0.45.1`


## Question 3. Count records

- Trips that started and finished on 2019-09-18
- Format timestamp(date and hour+min+sec) to date.

```sql
SELECT COUNT(*) FROM "csv_green_tripdata_2019_09"
WHERE DATE("lpep_pickup_datetime") = '2019-09-18' AND
      DATE("lpep_dropoff_datetime") = '2019-09-18';
```
```
+-------+
| count |
|-------|
| 15612 |
+-------+
```

Answer: `15612`


## Question 4. Longest trip for each day
```sql
SELECT
    DATE("lpep_pickup_datetime") AS "pickup_date",
    MAX("trip_distance") AS "longest_trip"
FROM
    "csv_green_tripdata_2019_09"
GROUP BY
    DATE("lpep_pickup_datetime")
ORDER BY
    "longest_trip" DESC
LIMIT 1;
```
```
+-------------+--------------+
| pickup_date | longest_trip |
|-------------+--------------|
| 2019-09-26  | 341.64       |
+-------------+--------------+
```

Answer: `2019-09-26`


## Question 5. Three biggest pickup zones
```sql
SELECT
    "zone"."Zone",
    ROUND(SUM(("total_amount")::NUMERIC), 3) AS "total_amount"
FROM
    "csv_green_tripdata_2019_09"
INNER JOIN
    "zone" ON "csv_green_tripdata_2019_09"."PULocationID" = "zone"."LocationID"
WHERE
    DATE("lpep_pickup_datetime") = '2019-09-18'
GROUP BY
    "zone"."Zone"
ORDER BY
    "total_amount" DESC
LIMIT 3;
```
```
+---------------------+--------------+
| Zone                | total_amount |
|---------------------+--------------|
| East Harlem North   | 17893.060    |
| East Harlem South   | 17152.160    |
| Morningside Heights | 11259.680    |
+---------------------+--------------+
```

Answer: `East Harlem North, East Harlem South, Morningside Heights`


## Question 6. Largest tip
```sql
SELECT
    puz."Zone" AS pickup_zone,
    doz."Zone" AS dropoff_zone,
    g."tip_amount"
FROM
    "csv_green_tripdata_2019_09" g
INNER JOIN
    "zone" puz ON g."PULocationID" = puz."LocationID"
INNER JOIN
    "zone" doz ON g."DOLocationID" = doz."LocationID"
WHERE
    puz."Zone" = 'Astoria'
ORDER BY
    g."tip_amount" DESC
LIMIT 1;
```

```
+-------------+--------------+------------+
| pickup_zone | dropoff_zone | tip_amount |
|-------------+--------------+------------|
| Astoria     | JFK Airport  | 62.31      |
+-------------+--------------+------------+
```

Answer: `JFK Airport`


## Question 7. Terraform Workflow

> self-explanatory
