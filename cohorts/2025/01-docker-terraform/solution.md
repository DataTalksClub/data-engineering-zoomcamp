## Question 1. Understanding docker first run
```
❯ docker run -it python:3.12.8 bash
root@ad53d4d6e8eb:/# pip --version
```
or 
```shell
docker run python:3.12.8 pip --version
```

Answer: `24.3.1`


## Question 2. Understanding Docker networking and docker-compose

- Spin that docker-compose.yml with `docker compose up -d`
- Log into pgadmin container with: `docker exec -it pgadmin bash`
- Test connectivity with `nc`

```shell
a9f4522e9e0b:/pgadmin4$ nc -zv db 5432
db (172.18.0.3:5432) open

a9f4522e9e0b:/pgadmin4$ nc -zv postgres 5432
postgres (172.18.0.3:5432) open
```

Both the service name (`db`) and the container name (`postgres`) can be used.
You should be aware that the port being used is the one exposed by the container (5432), not the port is set as port-forwarding (5433)

Answer: `postgres:5432` or `db:5432`


## Question 3. Trip Segmentation Count

- Trips that Happened (past tense), not "were happening"
- Period: October 1st 2019 (inclusive) and November 1st 2019 (exclusive)

```sql
select
    case
        when trip_distance <= 1 then 'Up to 1 mile'
        when trip_distance > 1 and trip_distance <= 3 then '1~3 miles'
        when trip_distance > 3 and trip_distance <= 7 then '3~7 miles'
        when trip_distance > 7 and trip_distance <= 10 then '7~10 miles'
        else '10+ miles'
    end as segment,
    to_char(count(1), '999,999') as num_trips
from
    green_taxi_trips
where
    lpep_pickup_datetime >= '2019-10-01'
    and lpep_pickup_datetime < '2019-11-01'
    and lpep_dropoff_datetime >= '2019-10-01'
    and lpep_dropoff_datetime < '2019-11-01'
group by
    segment
```
```
+--------------+----------------+
| segment      | num_trips      |
|--------------+----------------+
| Up to 1 mile | 104,802        |
| 1~3 miles    | 198,924        |
| 3~7 miles    | 109,603        |
| 7~10 miles   | 27,678         |
| 10+ miles    | 35,189         |
```

Answer: `104,802; 198,924; 109,603; 27,678; 35,189`


## Question 4. Longest trip for each day
```sql
select
    lpep_pickup_datetime::date as pickup_date,
    max(trip_distance) as longest_trip
from
    green_taxi_trips
group by
    lpep_pickup_datetime::date
order by
    longest_trip desc
limit 1
```
```
+-----------------------+----------------+
| pickup_date           | longest_trip   |
+-----------------------+----------------+
| 2019-10-31            | 515.89         |
```

Answer: `2019-10-31`


## Question 5. Three biggest pickup zones
```sql
select
    z.zone,
    round(sum(total_amount)::numeric, 3) as grand_total_amount
from
    green_taxi_trips g
inner join
    zone_lookup z on g.pu_location_id = z.location_id
where
    lpep_pickup_datetime::date = '2019-10-18'
group by
    z.zone
order by
    grand_total_amount desc
limit 3
```
```
+-----------------------+----------------------+
| zone                  | grand_total_amount   |
+-----------------------+----------------------+
| East Harlem North     | 18686.68             |
| East Harlem South     | 16797.26             |
| Morningside Heights   | 13029.79             |
```

Answer: `East Harlem North, East Harlem South, Morningside Heights`


## Question 6. Largest tip
```sql
select
    puz.zone as pickup_zone,
    doz.zone as dropoff_zone,
    g.tip_amount
from
    green_taxi_trips g
inner join
    zone_lookup puz on g.pu_location_id = puz.location_id
inner join
    zone_lookup doz on g.do_location_id = doz.location_id
where
    puz.zone = 'East Harlem North'
order by
    g.tip_amount desc
limit 1
```

```
+-------------------+---------------------+------------+
| pickup_zone       | dropoff_zone        | tip_amount |
|-------------------+---------------------+------------|
| East Harlem North | JFK Airport         | 87.3       |
```

Answer: `JFK Airport`


## Question 7. Terraform Workflow

> Downloading the provider plugins and setting up backend: 

- `terraform init`

> Generating proposed changes and auto-executing the plan: 

- `terraform apply -auto-approve`

> Remove all resources managed by terraform`

- `terraform destroy`

Answer:

```
terraform init, terraform apply -auto-approve, terraform destroy
```
