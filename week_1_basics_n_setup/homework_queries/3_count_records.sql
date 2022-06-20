/*
How many taxi trips were there on January 15?

Consider only trips that started on January 15.
*/

SELECT
    COUNT(*)
FROM yellow_taxi_data
WHERE
    tpep_pickup_datetime::date = '2021-01-15'

-- 53,024