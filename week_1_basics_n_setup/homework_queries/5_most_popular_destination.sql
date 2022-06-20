/*
What was the most popular destination for passengers picked up 
in central park on January 14?

Use the pick up time for your calculations.

Enter the zone name (not id). If the zone name is unknown (missing), write "Unknown" 
*/

SELECT
    COALESCE(dro."Zone", 'Unknown') as dropoff
    ,COUNT(*)
FROM yellow_taxi_data t
LEFT JOIN lookups pu
    ON t."PULocationID" = pu."LocationID"
LEFT JOIN lookups dro
    ON t."DOLocationID" = dro."LocationID"
WHERE
    tpep_pickup_datetime::date = '2021-01-14'
    AND pu."Zone" = 'Central Park'
GROUP BY 1
ORDER BY 2 DESC

-- Upper East Side South, 97 times
