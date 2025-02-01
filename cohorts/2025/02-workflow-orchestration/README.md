## Module 2 Homework Scripts and Answers

### Assignment 
Data Load for 2021 using for loop: hoemwork_load_taxi_data_forloop.yaml

### Quiz
1. 128.3 MB

2. green_tripdata_2020-04.csv

3. 24,648,499 (closest one)
```SQL 
SELECT COUNT(*) 
FROM `zoomcamp.yellow_tripdata` 
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) = 2020
```

4. 1,734,051 (closest one)
```SQL
SELECT COUNT(*) 
FROM `zoomcamp.green_tripdata` 
WHERE EXTRACT(YEAR FROM lpep_pickup_datetime) = 2020
```

5. 1,925,152 (closest one)
```SQL 
SELECT COUNT(*) 
FROM `zoomcamp.yellow_tripdata` 
WHERE EXTRACT(YEAR FROM tpep_pickup_datetime) = 2021 AND EXTRACT(MONTH FROM tpep_pickup_datetime) = 3
```

6. Add a timezone property set to America/New_York in the Schedule trigger configuration


