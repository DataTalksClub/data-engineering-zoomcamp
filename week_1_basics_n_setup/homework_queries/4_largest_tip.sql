/*
Find the largest tip for each day.

On which day it was the largest tip in January?

Use the pick up time for your calculations.

(note: it's not a typo, it's "tip", not "trip")
*/

SELECT
    tpep_pickup_datetime::date as pickup_date
    ,MAX(tip_amount) as max_tip
FROM yellow_taxi_data
GROUP BY 1
ORDER BY 2 DESC

-- largest tip $1,140.44 on Jan 20
