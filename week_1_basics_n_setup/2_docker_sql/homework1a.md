**Question 1:**
`--iidfile string`
```bash
docker build --help
```

**Question 2:**
3
```bash
docker run -it --entrypoint=bash python:3.9
```

**Question 3:**
20530
```sql
select count(*)
from green_taxi_trips
where date_trunc('day', lpep_pickup_datetime)='2019-01-15'
	and date_trunc('day', lpep_dropoff_datetime)='2019-01-15'
```

**Question 4:**
2019-01-15
```sql
select *	
from green_taxi_trips
order by trip_distance desc
limit 1
```

**Question 5:**
2: 1282; 3: 254
```sql
select
	passenger_count,
	count(*)
from green_taxi_trips
where date_trunc('day', lpep_pickup_datetime) = '2019-01-01'
	and passenger_count between 2 and 3
group by 1
```

**Question 6:**
Long Island City/Queens Plaza
```sql
select dropoff."Zone"

from green_taxi_trips trips
	left join zones pickup on trips."PULocationID" = pickup."LocationID"
	left join zones dropoff on trips."DOLocationID" = dropoff."LocationID"

where pickup."Zone" = 'Astoria'
order by trips.tip_amount desc
limit 1
```

