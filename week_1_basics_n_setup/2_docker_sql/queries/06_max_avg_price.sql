SELECT pu_zone."Zone" || ' / ' || 
CASE 
WHEN (do_zone."Zone" <> '') IS NOT TRUE THEN 'Unknown' 
WHEN (do_zone."Zone" <> '') IS TRUE  THEN do_zone."Zone" 
END as result
FROM 
(SELECT "PULocationID", "DOLocationID", AVG(total_amount) as avg_price
		from yellow_tripdata 
		group by "PULocationID", "DOLocationID"
		order by 3 desc
		limit 1) as yt
LEFT JOIN zones as do_zone on yt."DOLocationID" = do_zone."LocationID"
LEFT JOIN zones as pu_zone on yt."PULocationID" = pu_zone."LocationID"