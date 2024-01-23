SELECT count(*)
FROM public.yellow_taxi_trips
where date(lpep_pickup_datetime) = '2019-09-18' and
date(lpep_dropoff_datetime) = '2019-09-18';

SELECT t.dropoff_datetime - t.pickup_datetime,
       t.lpep_pickup_datetime,
	   t.lpep_dropoff_datetime,
	   t.trip_distance,
	   t."PULocationID",
	   t."DOLocationID"

FROM (
	SELECT cast(lpep_pickup_datetime as timestamp) as pickup_datetime,
	   cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime,
	   lpep_pickup_datetime,
	   lpep_dropoff_datetime,
	   trip_distance,
	   "PULocationID",
	   "DOLocationID"
FROM public.yellow_taxi_trips
) as t
where cast(lpep_dropoff_datetime as date) = cast(lpep_pickup_datetime as date)
order by t.dropoff_datetime - t.pickup_datetime desc
;


SELECT "Borough", SUM(total_amount) as total
FROM public.yellow_taxi_trips as ts
right join zones as zs on ts."PULocationID" = zs."LocationID"
where date(lpep_pickup_datetime) = '2019-09-18'
group by 1;


SELECT zspu."Borough" as PUBorough,
	   zsdo."Borough" as DOBorough,
	   ts.tip_amount
FROM public.yellow_taxi_trips ts
join zones zspu on ts."PULocationID" = zspu."LocationID"
join zones zsdo on ts."DOLocationID" = zsdo."LocationID"
where cast(lpep_pickup_datetime as date) between '2019-09-01' and '2019-09-30'
and zspu."Zone" = 'Astoria'
order by ts.tip_amount desc;
