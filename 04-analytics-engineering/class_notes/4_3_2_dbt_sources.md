# DE Zoomcamp 4.3.2 — dbt Sources

> 📄 Video: [dbt Sources](https://www.youtube.com/watch?v=7CrrXazV_8k)  
> 📄 Official docs: [Sources](https://docs.getdbt.com/docs/build/sources)  
> 📄 Best practices: [How we structure our dbt projects — Staging](https://docs.getdbt.com/best-practices/how-we-structure/03-staging)

This video is about telling dbt where your raw data actually lives. Sources are how dbt knows which tables to pull from before any transformation happens. Everything in this video takes place inside the `models/staging/` folder that we set up in 4.3.1.

---

## Defining Sources

### `sources.yml`
- A **YAML file** inside `models/staging/` that tells dbt where your raw data is
- The **name** of the file is arbitrary — common choices are `sources.yml`, `_sources.yml` (underscore so it sorts to the top), or something named after the origin like `bigquery_sources.yml`
- You give your source a **name** — this is arbitrary too. Think of it as a label: `raw`, `raw_data`, or something more descriptive like `google_analytics_data` or `finance_data`
- Then you provide three fields that are **not** arbitrary — they must exactly match your warehouse:
  - **database** — the database name or GCP project
  - **schema** — the schema inside that database or BigQuery dataset
  - **tables** — the individual tables you want to reference

```yaml
sources:
  - name: nytaxi
    database: taxi_rides_ny # Or name of your GCP project
    schema: prod # Or name of your BigQuery dataset
    
    tables:
      - name: green_tripdata
      - name: yellow_tripdata
```

> 📄 [Sources — full reference](https://docs.getdbt.com/docs/build/sources)

### Local (DuckDB) vs BigQuery — what goes where

The meaning of database, schema, and tables changes depending on your setup:

| Field | Local (DuckDB) | BigQuery |
|---|---|---|
| **database** | `taxi_rides_ny` | Your GCP Project ID |
| **schema** | `main` | Your BigQuery Dataset name (e.g. `trips_data_all`) |
| **tables** | `green_tripdata`, `yellow_tripdata` | Same table names |

- If you followed the default local setup, these names should be exactly right out of the box
- If you're on BigQuery, just double-check that your table names match what you actually have in your dataset

---

## Using Sources in Your Models

### The `source()` function
- Instead of hard-coding the full path to your table (e.g. `FROM production.trips_data_all.green_tripdata`), you use the **`source()`** function
- It's a **Jinja macro** — you'll recognize it by the double curly brackets `{{ }}`
- It takes two arguments:
  - The **source name** — the one you defined in your YAML (e.g. `staging`)
  - The **table name** — must match exactly what you put under `tables` in the YAML
- As long as there's a YAML file somewhere in your project with a matching source declaration, this will resolve correctly at compile time

```sql
select * from {{ source('staging', 'green_tripdata') }}
```

- Run a preview and you should see the raw table data come back
- If it works, that's the foundation — everything else builds on this

---

## Building a Proper Staging Model

### Naming convention
- Prefix your staging model files with **`stg_`** to make it clear what layer they belong to
- So `green_tripdata.sql` becomes `stg_green_tripdata.sql`
- Other common prefixes: `int_` for intermediate, and sometimes nothing at all for final mart models

### Rename and reorder columns
- List out every column explicitly and give them **cleaner aliases**
- Be purposeful about the **order** — it should follow a logical grouping:
  - **Identifiers first** — `vendor_id`, `trip_id`, anything that's an ID
  - **Timestamps next** — `pickup_datetime`, `dropoff_datetime`
  - **Trip details** — `passenger_count`, `trip_distance`, `trip_type`
  - **Payment info last** — `fare_amount`, `extra`, `mta_tax`, `tip_amount`, `tolls_amount`, `total_amount`, `payment_type`

### Cast data types explicitly
- Don't rely on whatever the source gave you — cast everything to the type you actually want:
  - IDs → `integer`
  - Timestamps → `timestamp`
  - Counts → `integer`
  - Monetary values → `numeric` or `float` (depends on your platform)

```sql
with tripdata as (
  select *
  from {{ source('staging','green_tripdata') }}
  where vendorid is not null 
),

renamed as (
  select
      -- identifiers
      cast(vendorid as integer) as vendorid,
      cast(ratecodeid as integer) as ratecodeid,
      cast(pulocationid as integer) as pickup_locationid,
      cast(dolocationid as integer) as dropoff_locationid,
      
      -- timestamps
      cast(lpep_pickup_datetime as timestamp) as pickup_datetime,
      cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime,
      
      -- trip info
      store_and_fwd_flag,
      cast(passenger_count as integer) as passenger_count,
      cast(trip_distance as numeric) as trip_distance,
      cast(trip_type as integer) as trip_type,
      
      -- payment info
      cast(fare_amount as numeric) as fare_amount,
      cast(extra as numeric) as extra,
      cast(mta_tax as numeric) as mta_tax,
      cast(tip_amount as numeric) as tip_amount,
      cast(tolls_amount as numeric) as tolls_amount,
      cast(ehail_fee as numeric) as ehail_fee,
      cast(improvement_surcharge as numeric) as improvement_surcharge,
      cast(total_amount as numeric) as total_amount,
      cast(payment_type as integer) as payment_type,
      {{ get_payment_type_description('payment_type') }} as payment_type_description
  from tripdata
)

select * from renamed
```

---

## A Note on Filtering

- The general recommendation is to keep staging models as **1:1 copies** of the source — same number of rows, same number of columns, just cleaned up
- That said, this dataset has some data quality issues (we'll cover those later), so it makes sense to filter out rows where **`vendor_id IS NULL`** right here in staging
- It's a deviation from convention, but a practical one for this project

---

## Your Exercise

Do the same thing for the **yellow tripdata** table. The columns are almost identical to green, so it shouldn't be too painful. By the end you should have:
- A `sources.yml` that declares both tables
- A `stg_green_tripdata.sql` staging model
- A `stg_yellow_tripdata.sql` staging model