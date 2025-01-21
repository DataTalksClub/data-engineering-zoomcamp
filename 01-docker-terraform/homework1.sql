SELECT count(1) from green_taxi_data where trip_distance <= 1; --104838
SELECT count(1) from green_taxi_data where trip_distance > 1 AND trip_distance <=3; --199013
SELECT count(1) from green_taxi_data where trip_distance > 3 AND trip_distance <=7; --109645
SELECT count(1) from green_taxi_data where trip_distance > 7 AND trip_distance <=10; --27688
SELECT count(1) from green_taxi_data where trip_distance > 10; --35202

SELECT lpep_pickup_datetime, trip_distance from green_taxi_data order by trip_distance desc limit 10; -- 2019-10-31

SELECT 
	SUM(t.total_amount), 
	z."Zone"
from 
	green_taxi_data t JOIN zones z
		on t."PULocationID" = z."LocationID"
where 
	t.lpep_pickup_datetime >= '2019-10-18 00:00:00' AND 
	t.lpep_pickup_datetime <=  '2019-10-18 23:59:59'
GROUP BY
	z."Zone"
HAVING
	SUM(t.total_amount) > 13000
ORDER BY
	SUM(t.total_amount) DESC
limit 10; -- East Harlem North, East Harlem South, Morningside Heights

SELECT 
	MAX(t.tip_amount), 
	zdo."Zone"
from 
	green_taxi_data t JOIN zones zpu
		on t."PULocationID" = zpu."LocationID"
	JOIN zones zdo
		on t."DOLocationID" = zdo."LocationID"
where 
	zpu."Zone" = 'East Harlem North' AND
	t.lpep_pickup_datetime >= '2019-10-01 00:00:00' AND 
	t.lpep_pickup_datetime <=  '2019-10-31 23:59:59'
GROUP BY
	zdo."Zone"
ORDER BY
	MAX(t.tip_amount) DESC
limit 10; -- JFK Airport
