SELECT DATE(tpep_pickup_datetime) as date, max(tip_amount) as max_tip 
FROM yellow_tripdata 
GROUP BY date 
ORDER BY max_tip desc 