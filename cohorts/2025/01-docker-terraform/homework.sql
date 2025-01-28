1.   24.3.1

2.   postgres:5432

3.
a.
SELECT COUNT(*) AS trips_up_to_1_mile
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01:00:00:00'
  AND lpep_dropoff_datetime < '2019-11-01:00:00:00'
  AND trip_distance <= 1;

b.
SELECT COUNT(*) AS trips_up_to_1_mile
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01:00:00:00'
  AND lpep_dropoff_datetime < '2019-11-01:00:00:00'
  AND trip_distance > 1
  AND trip_distance <= 3;

c.
SELECT COUNT(*) AS trips_up_to_1_mile
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01:00:00:00'
  AND lpep_dropoff_datetime < '2019-11-01:00:00:00'
  AND trip_distance > 3
  AND trip_distance <= 7;

d.
SELECT COUNT(*) AS trips_up_to_1_mile
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01:00:00:00'
  AND lpep_dropoff_datetime < '2019-11-01:00:00:00'
  AND trip_distance > 7
  AND trip_distance <= 10;

e.
SELECT COUNT(*) AS trips_up_to_1_mile
FROM public.green_taxi_data
WHERE lpep_pickup_datetime >= '2019-10-01:00:00:00'
  AND lpep_dropoff_datetime < '2019-11-01:00:00:00'
  AND trip_distance > 10;

4.
SELECT lpep_pickup_datetime::DATE, MAX(trip_distance) AS longest_trip_distance
FROM green_taxi_data
WHERE lpep_pickup_datetime::DATE IN ('2019-10-11', '2019-10-24', '2019-10-26', '2019-10-31')
GROUP BY lpep_pickup_datetime::DATE
order by longest_trip_distance DESC;

5.
SELECT zone."Zone" AS pickup_location, SUM(total_amount) AS total_amount_sum
FROM public.green_taxi_data AS gtd
JOIN public.zones AS zone
ON gtd."PULocationID" = zone."LocationID"
WHERE gtd.lpep_pickup_datetime::DATE = '2019-10-18'
GROUP BY zone."Zone"
HAVING SUM(total_amount) > 13000
ORDER BY total_amount_sum DESC;

6.
SELECT dz."Zone" AS dropoff_zone, MAX(tip_amount) AS max_tip
FROM public.green_taxi_data AS gtd
JOIN public.zones AS pz ON gtd."PULocationID" = pz."LocationID"
JOIN public.zones AS dz ON gtd."DOLocationID" = dz."LocationID"
WHERE pz."Zone" = 'East Harlem North'
  AND gtd.lpep_pickup_datetime >= '2019-10-01'
  AND gtd.lpep_pickup_datetime < '2019-11-01'
GROUP BY dz."Zone"
ORDER BY max_tip DESC
LIMIT 1;

7.
terraform init, terraform apply -auto-approve, terraform destroy
