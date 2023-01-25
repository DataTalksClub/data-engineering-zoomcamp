--QUESTION 3
SELECT
    COUNT(*)
FROM
    public.green_tripdata
WHERE
    lpep_pickup_datetime >= '2019-01-15 00:00:00'
    AND lpep_pickup_datetime < '2019-01-16 00:00:00';


--QUESTION 4
SELECT
    lpep_pickup_datetime
FROM
    public.green_tripdata
WHERE
    trip_distance = (SELECT
                         MAX(trip_distance)
                     FROM
                         public.green_tripdata);

--QUESTION 5
SELECT
    passenger_count
    , COUNT(*)
FROM
    public.green_tripdata
WHERE
    lpep_pickup_datetime::DATE = '2019-01-01'
	AND passenger_count IN (2,3)
GROUP BY
	passenger_count;

--QUESTION 6
SELECT
    MAX(tip_amount), dz."Zone"
FROM
    public.green_tripdata t
LEFT JOIN public.taxi_zones pz ON
	t."PULocationID" = pz."LocationID"
LEFT JOIN public.taxi_zones dz ON
	t."DOLocationID" = dz."LocationID"
WHERE
    pz."Zone" = 'Astoria'
GROUP BY
    dz."Zone"
ORDER BY
    MAX(tip_amount) DESC
LIMIT 1;
