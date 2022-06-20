/*
What's the pickup-dropoff pair with the largest 
average price for a ride (calculated based on `total_amount`)?

Enter two zone names separated by a slash

For example:

"Jamaica Bay / Clinton East"

If any of the zone names are unknown (missing), write "Unknown". For example, "Unknown / Clinton East". 
*/

SELECT
    COALESCE(pu."Zone", 'Unknown') || ' / ' || COALESCE(dro."Zone", 'Unknown') as pickup_dropoff_zone
    ,AVG(t.total_amount) as avg_total_amt
    ,COUNT(*) as total_trips
FROM yellow_taxi_data t
LEFT JOIN lookups pu
    ON t."PULocationID" = pu."LocationID"
LEFT JOIN lookups dro
    ON t."DOLocationID" = dro."LocationID"
GROUP BY 1
ORDER BY 2 DESC

-- 1) Alphabet City / Unknown for $2,292.40 (potentially a data error)
-- 2) Union Sq / Canarsie for $262.85
