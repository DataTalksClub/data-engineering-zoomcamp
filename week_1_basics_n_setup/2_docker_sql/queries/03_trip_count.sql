SELECT COUNT(1) 
FROM yellow_tripdata 
WHERE EXTRACT(MONTH from tpep_pickup_datetime) = 1 AND EXTRACT(DAY from tpep_pickup_datetime) = 15