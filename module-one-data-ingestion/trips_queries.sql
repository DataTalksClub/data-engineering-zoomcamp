SELECT count(*) AS Total_Trips,
	CASE WHEN trip_distance <= 1.0 THEN 'Up_To_1_Mile'
		WHEN trip_distance > 1.0 AND trip_distance <= 3.0 THEN 'Between_1_and_3'
		WHEN trip_distance > 3.0 AND trip_distance <= 7.0 THEN 'Between_3_and_7'
		WHEN trip_distance > 7.0 AND trip_distance <= 10.0 THEN 'Between_7_and_10'
		WHEN trip_distance > 10.0 THEN 'Over_10_Miles' END AS Distance
FROM public.trips
where CAST(lpep_pickup_datetime AS DATE) >= '2019-10-01'::date and CAST(lpep_dropoff_datetime AS DATE) < '2019-11-01'::date
GROUP BY Distance


SELECT
    zl."Zone" as pickup_zone,
    SUM(total_amount) as total_amount
FROM trips g
JOIN zones zl ON g."PULocationID" = zl."LocationID"
WHERE DATE(lpep_pickup_datetime) = '2019-10-18'
GROUP BY zl."Zone"
HAVING SUM(total_amount) > 13000
ORDER BY total_amount DESC;

SELECT
   zl_dropoff."Zone" as dropoff_zone,
   MAX(tip_amount) as largest_tip
FROM trips g
JOIN zones zl_pickup ON g."PULocationID" = zl_pickup."LocationID"
JOIN zones zl_dropoff ON g."DOLocationID" = zl_dropoff."LocationID"
WHERE zl_pickup."Zone" = 'East Harlem North'
   AND DATE_TRUNC('month', lpep_pickup_datetime) = '2019-10-01'
GROUP BY zl_dropoff."Zone"
ORDER BY largest_tip DESC
LIMIT 1;