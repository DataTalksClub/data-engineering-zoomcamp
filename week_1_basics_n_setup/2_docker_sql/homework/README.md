## Set up

I used the modified docker-compose.yaml to raise the pg containers.

I used the run_ingest_data_2.sh script to inject the 2 data sources into the pg via the ingest_data_2.py script.

## Question 1

I used this command to get the answer.

```bash
docker build --help | grep image
```

## Question 2

I used these commands to get the answer.

```bash
docker run -it --entrypoint bash python:3.9
pip list
```

## Question 3

I used the following sql statement.

```sql
select count(pu_dt) from (
	select
		cast(lpep_pickup_datetime as date) as pu_dt,
		cast(lpep_dropoff_datetime as date) as do_dt
	from trips_2019
	where
		cast(lpep_pickup_datetime as date)=cast(lpep_dropoff_datetime as date)
		and extract(month from cast(lpep_pickup_datetime as date))='1'
		and extract(day from cast(lpep_pickup_datetime as date))='15'
) as t
```

## Question 4

I used the following sql statement.

```sql
select
	max(trip_distance) as highest_trip_distance,
	cast(lpep_pickup_datetime as date) as pu_dt
from trips_2019
group by pu_dt
order by highest_trip_distance desc;
```

## Question 5

I used the following sql statement.

```sql
select count(index)
from trips_2019
where
	passenger_count=2
	and cast(lpep_pickup_datetime as date)='2019-01-01';
```

## Question 6

I used the following sql statement.

```sql
select zones."Zone", max_tip
from (
	select max(trips."tip_amount") as max_tip, trips."DOLocationID"
	from trips_2019 as trips
	join zones
	on trips."PULocationID"=zones."LocationID"
	where zones."Zone"='Astoria'
	group by trips."DOLocationID"
) as max_tips_by_zone
join zones
on max_tips_by_zone."DOLocationID"=zones."LocationID"
order by max_tip desc;
```
