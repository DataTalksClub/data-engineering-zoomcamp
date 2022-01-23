# Question 3: Count records
How many taxi trips were there on January 15?
```
SELECT COUNT(*) FROM public.yellow_taxi_data WHERE DATE(tpep_pickup_datetime) = '2021-01-15'
```

# Question 4: Largest tip for each day
On which day it was the largest tip in January? (note: it's not a typo, it's "tip", not "trip")
```
SELECT * FROM public.yellow_taxi_data WHERE tip_amount = (SELECT MAX(tip_amount) FROM public.yellow_taxi_data )
```

# Question 5: Most popular destination
What was the most popular destination for passengers picked up in central park on January 14? Enter the zone name (not id). If the zone name is unknown (missing), write "Unknown"
```
SELECT
  do_zones."Zone",
  COUNT(*) count
FROM public.yellow_taxi_data 
LEFT JOIN public.zones AS pu_zones
       ON yellow_taxi_data."PULocationID" = pu_zones."LocationID"
LEFT JOIN public.zones AS do_zones
       ON yellow_taxi_data."DOLocationID" = do_zones."LocationID"
WHERE pu_zones."Zone" = 'Central Park'
GROUP BY do_zones."Zone"
ORDER BY count DESC
LIMIT 100
```

# Question 6: Most expensive route
What's the pickup-dropoff pair with the largest average price for a ride (calculated based on total_amount)? Enter two zone names separated by a slashFor example:"Jamaica Bay / Clinton East"If any of the zone names are unknown (missing), write "Unknown". For example, "Unknown / Clinton East".
```
SELECT
  pu_zones."Zone",
  do_zones."Zone",
  AVG(total_amount) total_amount
FROM public.yellow_taxi_data 
LEFT JOIN public.zones AS pu_zones
       ON yellow_taxi_data."PULocationID" = pu_zones."LocationID"
LEFT JOIN public.zones AS do_zones
       ON yellow_taxi_data."DOLocationID" = do_zones."LocationID"
GROUP BY 
  pu_zones."Zone",
  do_zones."Zone"
ORDER BY total_amount DESC
LIMIT 100
```
