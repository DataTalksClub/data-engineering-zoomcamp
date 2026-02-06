# DE Zoomcamp 4.4.1 — dbt Models

> 📄 Video: [dbt Models](https://www.youtube.com/watch?v=JQYz-8sl1aQ)  
> 📄 Official docs: [SQL models](https://docs.getdbt.com/docs/build/sql-models)  
> 📄 ref() function: [About ref](https://docs.getdbt.com/reference/dbt-jinja-functions/ref)

Staging is done. From here on out it's not just typing SQL behind a computer — you need to actually **explore the data**, understand what's in it, and get some **business context**. In a real org that means querying exhaustively until you understand the common data quality issues, what a normal row looks like, and talking to people about what the codes mean and when rows trigger. All of that understanding eventually gets encoded as SQL.

---

## What are we building?

Before writing any code, it helps to think about what the end result should look like. There are generally two things you want in your marts:

### Reports and dashboards
- If there's an important dashboard or data application out there — especially one that requires a lot of manual work or spreadsheet maintenance — that's a sign it should become a dbt model
- Example: imagine there's a dashboard with a dataset called **monthly revenue per location**. That's something we want to build and version-control properly

### A dimensional model
- Beyond reports, you want a proper **star schema** — the kind of structure you see in data warehouses
- Two key table types to know:
  - **Fact tables** — one row per event/process. One row per trip, one row per sale, one row per order. Named with a `fct_` prefix (e.g. `fct_trips`)
  - **Dimension tables** — attributes of an entity. Named with a `dim_` prefix (e.g. `dim_zones`, `dim_vendors` is not shown here)
- The power of a good star schema: answering "how many?" questions becomes trivial. *How many zones do we have?* → `COUNT(*)` on `dim_zones`. *How many trips?* → `COUNT(*)` on `fct_trips`. Simple, focused tables that you join when you need something more complex

### What we're building in this course
- `dim_zones` — zone/location attributes  
- `fct_trips` — one row per trip (yellow + green combined)
- A report model for monthly revenue per zone (inside a `models/core/` folder)

---

## source() vs ref() — the key distinction

This is an important moment in the course. Up until now we've been using `{{ source() }}` to pull in raw data. But that's **only** for things declared in your sources YAML — i.e. raw tables that live outside of dbt.

If the input to your model is **another dbt model**, you use `{{ ref() }}` instead.

- `{{ source('name', 'table') }}` → raw data defined in your YAML
- `{{ ref('model_name') }}` → another dbt model

> 📄 [ref() — full reference](https://docs.getdbt.com/reference/dbt-jinja-functions/ref)

This distinction matters because `ref()` also does something useful under the hood: it automatically builds the **dependency graph**. dbt knows that if model B refs model A, then A has to run first. You never have to manage run order yourself.

---

## The intermediate layer — why it exists

We want `fct_trips` to be a union of yellow and green trip data. But doing that union directly inside the fact model would make it messy. So we put it in an **intermediate model** instead — something that's not raw, and not ready to expose to end users.

- Convention: prefix intermediate models with `int_`  
- In this case: `int_trips_unioned.sql`
- The idea is to keep intermediate work out of marts. Marts should only contain things that are consumption-ready

```sql
with green_data as (
    select *, 
        'Green' as service_type 
    from {{ ref('stg_green_tripdata') }}
), 

yellow_data as (
    select *, 
        'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata') }}
), 

trips_unioned as (
    select * from green_data
    union all
    select * from yellow_data
)

select * from trips_unioned
```

---

## The union problem — yellow and green aren't identical

When you try to union the two staging models, it fails. The error: *set operation can only be applied with expressions with the same number of columns*. Turns out green has **two extra columns** that yellow doesn't:

### `trip_type`
- Values are `1` or `2`
- `1` = street hail (you flag down the taxi)
- `2` = booked via phone or app
- Yellow taxis **don't have this column** because by law you can only get a yellow taxi by hailing it on the street — it's always type 1
- Fix: add `trip_type` to the yellow staging model and hard-code it as `1` (street hail)

### `ehail_fee` (e-hail fee)
- An extra fee that can apply when you request a taxi through an app
- In practice, most of this data is null — the feature isn't consistently implemented across vendors
- Yellow taxis by definition **never** have an e-hail fee
- Fix: add `ehail_fee` to the yellow staging model and hard-code it as `0`

```sql
-- Updated stg_yellow_tripdata.sql to match green schema
with tripdata as (
  select *
  from {{ source('staging','yellow_tripdata') }}
  where vendorid is not null 
),

renamed as (
    select
        -- identifiers
        cast(vendorid as integer) as vendor_id,
        cast(ratecodeid as integer) as ratecode_id,
        cast(pulocationid as integer) as pickup_location_id,
        cast(dolocationid as integer) as dropoff_location_id,
        
        -- timestamps
        cast(tpep_pickup_datetime as timestamp) as pickup_datetime,
        cast(tpep_dropoff_datetime as timestamp) as dropoff_datetime,
        
        -- trip info
        store_and_fwd_flag,
        cast(passenger_count as integer) as passenger_count,
        cast(trip_distance as numeric) as trip_distance,
        cast(1 as integer) as trip_type,  -- Yellow only does street-hail
        
        -- payment info
        cast(fare_amount as numeric) as fare_amount,
        cast(extra as numeric) as extra,
        cast(mta_tax as numeric) as mta_tax,
        cast(tip_amount as numeric) as tip_amount,
        cast(tolls_amount as numeric) as tolls_amount,
        cast(0 as numeric) as ehail_fee,  -- Yellow doesn't have ehail
        cast(improvement_surcharge as numeric) as improvement_surcharge,
        cast(total_amount as numeric) as total_amount,
        cast(payment_type as integer) as payment_type,
    from tripdata
)

select * from renamed
```

A note: adding these columns directly in staging is technically a break from the "1:1 copy" rule. It's done here to keep things simple, but in a stricter project you'd handle this in the intermediate layer.

**Updated union after schema alignment:**

```sql
-- models/staging/int_trips_unioned.sql
with green_data as (
    select *, 
        'Green' as service_type 
    from {{ ref('stg_green_tripdata') }}
), 

yellow_data as (
    select *, 
        'Yellow' as service_type
    from {{ ref('stg_yellow_tripdata') }}
), 

trips_unioned as (
    select * from green_data
    union all
    select * from yellow_data
)

select * from trips_unioned
```

---

## Why the business context matters

The column discrepancy between yellow and green isn't just a technical problem — it's a **business story**. Yellow and green taxis exist because of how NYC taxi licensing works: yellow cabs stay in Manhattan, green cabs were created so people in the outer boroughs could get rides too. Understanding that context is what lets you make the right call on how to handle `trip_type` and `ehail_fee` — not just technically, but semantically.

This is the part of analytics engineering where you stop just writing SQL and start understanding what the data actually represents.