**Example count of record:**

```
SELECT count(*) 
FROM green_taxi_data 
WHERE CAST(lpep_pickup_datetime AS DATE) = '2019-09-18' AND CAST(lpep_dropoff_datetime AS DATE) = '2019-09-18'
```

**Largest pickup boroughs**

```
SELECT z."Borough", SUM(g."total_amount") as max_tip_amoumt 
FROM green_taxi_data g LEFT JOIN taxi_zone z on g."PULocationID" = z."LocationID" 
WHERE  CAST(lpep_pickup_datetime AS DATE) = '2019-09-18' 
GROUP BY 1  
ORDER BY 2 DESC
```

**Day with largest tip**
```
SELECT lpep_pickup_datetime 
FROM green_taxi_data WHERE trip_distance = (SELECT max(trip_distance) FROM green_taxi_data)

```


**Largest Tip zone**
```
SELECT z1."Zone", MAX(g."tip_amount") as max_tip_amoumt FROM green_taxi_data g 
LEFT JOIN taxi_zone z on g."PULocationID" = z."LocationID" 
LEFT JOIN taxi_zone z1 on g."DOLocationID" = z1."LocationID" 
WHERE z."Zone" = 'Astoria' 
GROUP BY 1 
ORDER BY 2 DESC
```
