SELECT "Zone" as result
FROM
    (SELECT "Zone" as pickup_zone, "DOLocationID", COUNT(1) as trip_count
    FROM yellow_tripdata
    LEFT JOIN zones ON "PULocationID" = "LocationID"
    WHERE EXTRACT(DAY FROM tpep_pickup_datetime) = 14 AND EXTRACT(MONTH FROM tpep_pickup_datetime) = 1 AND "Zone" = 'Central Park'
    GROUP BY "DOLocationID", "Zone"
    ORDER BY trip_count desc
    Limit 1
    ) as a
left join zones on a."DOLocationID" = zones."LocationID"