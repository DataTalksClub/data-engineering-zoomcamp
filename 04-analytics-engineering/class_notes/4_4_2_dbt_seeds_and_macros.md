# DE Zoomcamp 4.4.2 — dbt Seeds and Macros

> 📄 Video: [dbt Seeds and Macros](https://www.youtube.com/watch?v=lT4fmTDEqVk)  
> 📄 Seeds docs: [Seeds](https://docs.getdbt.com/docs/build/seeds)  
> 📄 Macros docs: [Jinja and macros](https://docs.getdbt.com/docs/build/jinja-macros)

The union model is done, but right now vendor IDs and location IDs are just numbers — meaningless codes. This video is about enriching that data. Two dbt features come in: **seeds** for bringing in lookup data, and **macros** for turning reusable SQL logic into something you don't have to copy-paste everywhere.

---

## The problem — codes everywhere

If you query `vendor_id`, you get values: 1 and 2. Those map to real companies:
- **1** → Creative Mobile Technologies
- **2** → VeriFone Inc.

Same story with locations — 265 location IDs that could have names, boroughs, coordinates, and more. The raw data just doesn't have any of that. So how do we add it?

---

## Seeds — bringing in lookup data

### What seeds are
- A way to **upload a CSV file** and make it available as a dbt model
- You drop the CSV into the `seeds/` directory, run `dbt seed`, and it becomes queryable just like any other model
- You reference it with `{{ ref('filename') }}` — same as any other model

### When to use them
- **Lookup tables** that don't exist anywhere in your warehouse yet
- Cases where you don't have write permissions to load data properly
- Quick experiments or local testing before committing to a proper data load
- Small, static datasets

### When NOT to use them
- **Never commit confidential data** — seeds go into your git repo
- Keep the data **small** — large CSVs in git will slow down pulls and pushes
- If you have the option to load the data properly at the source, do that instead. Seeds are a quick-and-dirty workaround

> 📄 [Seeds — full reference](https://docs.getdbt.com/docs/build/seeds)

---

## dim_zones — using a seed in practice

The taxi zone lookup CSV has exactly what we need: location ID, borough, zone name, and service area. Drop it into `seeds/`, run `dbt seed`, and it's live.

Now we build `dim_zones`. The model simply selects from the seed and renames columns to something cleaner.

```sql
select
    locationid as location_id,
    borough,
    zone,
    service_zone
from {{ ref('taxi_zone_lookup') }}
```

That's it — first dimension table done. The seed did the heavy lifting.

---

## dim_vendors — the CASE WHEN problem (not implemented in this project, but shown for learning)

For vendors, we could pull distinct `vendor_id` from the intermediate union model using `ref()`. Easy enough. But we want to enrich it with vendor **names**.

### The naive approach: CASE WHEN
You could just write it inline:

```sql
with vendors as (
    select distinct vendorid
    from {{ ref('stg_green_tripdata') }}
)

select
    vendorid,
    case 
        when vendorid = 1 then 'Creative Mobile Technologies, LLC'
        when vendorid = 2 then 'VeriFone Inc.'
        else 'Unknown'
    end as vendor_name
from vendors
```

This works. But it has a real problem: **what happens when a new vendor appears, or a vendor changes its name?** You have to open this file, find the CASE block, and add another line. And if you need the same mapping somewhere else in the project, you copy-paste the whole thing. Eventually someone forgets to update one of the copies.

### The better approach: macros

Macros are dbt's answer to this. Think of them as **reusable SQL functions** — same idea as a Python function, but for SQL snippets.

> 📄 [Jinja and macros — full reference](https://docs.getdbt.com/docs/build/jinja-macros)

### How macros work
- Defined in `.sql` files inside the `macros/` directory
- You wrap your SQL logic in `{% macro macro_name(argument) %}` ... `{% endmacro %}`
- The argument works just like a function parameter — you pass in a value when you call it
- You call it in your models with `{{ macro_name(argument) }}`
- dbt compiles it down — the final SQL looks exactly like you typed the CASE block inline, but your source code stays clean

```sql
{% macro get_vendor_data(vendor_id_column) %}

{% set vendors = {
    1: 'Creative Mobile Technologies',
    2: 'VeriFone Inc.',
    4: 'Unknown/Other'
} %}

case {{ vendor_id_column }}
    {% for vendor_id, vendor_name in vendors.items() %}
    when {{ vendor_id }} then '{{ vendor_name }}'
    {% endfor %}
end

{% endmacro %}

```

**Using the macro in a model:**

```sql
with trips as (
    select * from {{ ref('fct_trips') }}
),

vendors as (
    select distinct
        vendor_id,
        {{ get_vendor_data('vendor_id') }} as vendor_name
    from trips
)

select * from vendors
```

### Why this is better
- **Reusable** — need the same payment type logic somewhere else? Just call the macro again
- **Single source of truth** — payment types change? Update the macro in one place, it's fixed everywhere
- **Testable** — the logic is isolated in its own file, easier to reason about

---

## Homework preview — fct_trips

The fact trips model is left as an exercise. Here's what's expected:

- **One row per trip** — yellow and green combined (the union is already done in the intermediate model)
- **Add a primary key** (`trip_id`) — it has to be **unique**
- **Find and fix duplicates** — there are quite a few in this dataset. Some come from the source, some get introduced during the union. Find them, understand why they happen, and fix them
- **Enrich `payment_type`** (there is a seed for this in the repo).