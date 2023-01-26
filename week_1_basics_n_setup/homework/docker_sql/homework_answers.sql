WITH aux AS (
	SELECT index, passenger_count, TO_CHAR(lpep_pickup_datetime::date, 'YYYY-MM-DD') as pickup_str,
	TO_CHAR(lpep_dropoff_datetime::date, 'YYYY-MM-DD') as dropoff_str
	FROM yellow_taxi_data
)

SELECT COUNT(index), passenger_count
FROM aux
WHERE pickup_str = '2019-01-01' AND passenger_count IN (2, 3)
GROUP BY passenger_count;

SELECT COUNT(DISTINCT index)
FROM aux
WHERE pickup_str = '2019-01-15' AND dropoff_str = '2019-01-15';

SELECT lpep_pickup_datetime, MAX(trip_distance) as max_distance
FROM yellow_taxi_data
GROUP BY lpep_pickup_datetime
ORDER BY max_distance DESC
LIMIT 1;



SELECT COUNT(DISTINCT index)
FROM aux
WHERE pickup_str = '2019-01-01'
GROUP BY passenger_count;

SELECT * 
FROM zones
WHERE "Zone" = 'Astoria';



SELECT z."Zone", MAX(y."tip_amount") as max_tip
FROM yellow_taxi_data AS y
LEFT JOIN zones AS z ON y."DOLocationID" = z."LocationID"
WHERE y."PULocationID" = 7
GROUP BY z."Zone"
ORDER BY max_tip DESC;