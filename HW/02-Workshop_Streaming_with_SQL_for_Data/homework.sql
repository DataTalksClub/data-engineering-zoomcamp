 -- Question 1
 #
CREATE MATERIALIZED VIEW taxi_trips_count AS
SELECT
  tz1.zone AS pickup_zone,
  tz2.zone AS dropoff_zone,
  COUNT(*) as number_trips,
  AVG(td.tpep_dropoff_datetime-td.tpep_pickup_datetime) AS avg_trip_time,
  MIN(td.tpep_dropoff_datetime-td.tpep_pickup_datetime) AS min_trip_time,
  MAX(td.tpep_dropoff_datetime-td.tpep_pickup_datetime) AS max_trip_time
FROM  
  trip_data td 
JOIN
  taxi_zone tz1 ON td.pulocationid = tz1.location_id
JOIN
  taxi_zone tz2 ON td.dolocationid = tz2.location_id
GROUP BY
  tz1.zone, tz2.zone;
#
SELECT
  number_trips,
  pickup_zone,
  dropoff_zone
FROM 
  taxi_trips_count
ORDER BY  
  avg_trip_time DESC
LIMIT 1;
#
 -- Question 2
#
DROP MATERIALIZED VIEW taxi_trips_stats;
CREATE MATERIALIZED VIEW taxi_trips_stats AS with t as (
SELECT
  pickup_zone.zone as pickup_taxi_zone,
  dropoff_zone.zone as dropoff_taxi_zone,
  t.tpep_pickup_datetime,
  t.tpep_dropoff_datetime,
  t.tpep_dropoff_datetime - t.tpep_pickup_datetime as trip_time
FROM
  trip_data as t
  inner join taxi_zone as pickup_zone ON t.pulocationid = pickup_zone.location_id
  inner join taxi_zone as dropoff_zone ON t.dolocationid = dropoff_zone.location_id
WHERE
  t.pulocationid <> t.dolocationid
)
SELECT
  pickup_taxi_zone,
  dropoff_taxi_zone,
  min(trip_time) as min_trip_time,
  max(trip_time) as max_trip_time,
  avg(trip_time) as avg_trip_time,
  count(*) as cnt
FROM
  t
GROUP BY
  pickup_taxi_zone,
  dropoff_taxi_zone;
#
 -- Question 3 
#
CREATE MATERIALIZED VIEW latest_pickup_time AS
SELECT tpep_pickup_datetime AS pickup_time
FROM trip_data
WHERE tpep_pickup_datetime=(SELECT MAX(tpep_pickup_datetime) FROM trip_data);
#
SELECT
  taxi_zone.Zone AS pickup_zone,
  COUNT(*) AS num_rides
FROM
  trip_data
  JOIN taxi_zone ON taxi_zone.location_id = trip_data.pulocationid
WHERE
  trip_data.tpep_pickup_datetime >= (
    SELECT
      pickup_time - INTERVAL '17 HOURS'
    FROM
      latest_pickup_time
  )
GROUP BY
  pickup_zone
ORDER BY
  num_rides DESC
LIMIT
  3;
