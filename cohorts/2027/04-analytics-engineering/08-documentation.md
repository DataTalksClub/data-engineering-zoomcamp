---
video_url: https://www.youtube.com/watch?v=UqoWyMjcqrA
---
# Documentation

> 📄 Official docs: [Documentation](https://docs.getdbt.com/docs/build/documentation)
> 📄 Model properties: [Model properties](https://docs.getdbt.com/reference/model-properties)

The models are built. Now it's time to make sure other people can actually understand what they do. This video covers how dbt's documentation system works — what you write, where you write it, and what dbt does with it.

---

## Where documentation lives — YAML files

You've already seen YAML files in the context of sources. But they do more than just declare where raw data lives — they're also the **primary place to document your entire project**.

The most common convention is to have a single file called `schema.yml` per directory. Some teams prefer **one YAML file per model** — that's fine too, it keeps things from getting unwieldy when projects get large. For this course we stick with `schema.yml`.

> 📄 [Model properties — full reference](https://docs.getdbt.com/reference/model-properties)

---

## What you can document

Almost everything in dbt can be documented. The structure is the same pattern regardless of what you're documenting:

### Sources

You already have a `sources.yml` — you can add descriptions to the source itself and to each table inside it.

```yaml
version: 2

sources:
  - name: staging
    description: >
      Raw NYC taxi trip data loaded from BigQuery external tables.
      Contains both yellow and green taxi trip records for 2019-2020.
    database: production
    schema: trips_data_all

    tables:
      - name: green_tripdata
        description: >
          Green taxi trip records. Green taxis operate primarily in
          outer boroughs (outside Manhattan).

      - name: yellow_tripdata
        description: Yellow taxi trips, primarily from Manhattan
```

### Models

In `schema.yml`, you switch from `sources:` to `models:`. Same idea — give each model a name and a description, then drill down into columns.

```yaml
version: 2

models:
  - name: dim_zones
    description: >
      Zone lookup table containing LocationID, borough, zone name and service zone.
      One row per taxi zone in NYC.
    columns:
      - name: locationid
        description: Primary key for taxi zones
        tests:
          - unique
          - not_null

      - name: borough
        description: NYC borough name (Manhattan, Queens, Brooklyn, Bronx, Staten Island, EWR)

      - name: zone
        description: Taxi zone name/neighborhood

      - name: service_zone
        description: Service zone type (Yellow, Green, or Airports)
```

### Columns
Under each model, you can list every column with:
- **name** — must match the actual column name
- **description** — what it means
- **data_type** — what type it should be (informational, not enforced)
- **tests** — we'll cover these in the next video, but the slot is here
- **meta** — custom key-value tags (more on this below)

### Macros and seeds
You can document these too, using the same YAML pattern. Same `version: 2` header, just different top-level keys.

---

## Multi-line descriptions

If you need more than one line for a description, use the YAML **pipe operator** (`|`) or **greater-than operator** (`>`). Everything indented under it becomes part of the description. The `>` folds newlines into spaces, while `|` preserves them.

```yaml
version: 2

models:
  - name: fct_trips
    description: |
      Fact table containing all taxi trips from both yellow and green taxis.

      This is the core analytical table for trip-level analysis.
      Each row represents a single trip with:
      - Trip identifiers and service type
      - Pickup and dropoff locations and timestamps
      - Trip details (distance, passenger count, etc.)
      - Payment information and amounts

      Data is filtered for 2019-2020 only and excludes records
      with unknown pickup or dropoff locations.
```

---

## Meta tags — custom metadata

The `meta` field lets you attach arbitrary key-value pairs to any column or model. There's no predefined set — you and your team decide what matters. Common examples:

- **PII** — flag columns that contain personally identifiable information
- **owner** — who's responsible for this data asset, who to contact if something breaks
- **importance** — mark which columns or models are critical vs. informational

These don't affect how dbt runs anything. They're purely for governance, discoverability, and helping your team navigate the project.

---

## Generating and viewing the docs

Two commands, run them in order:

### `dbt docs generate`
- Compiles everything — your YAML descriptions, your model code, and metadata from the warehouse (like actual column types and table sizes) — into a JSON file
- In **dbt Cloud**, this happens automatically. There's even a checkbox for it
- In **dbt Core**, you have to run it yourself

### `dbt docs serve`
- Takes the generated JSON and spins up a local website (defaults to `localhost:8080`)
- Only needed if you're on **dbt Core** — dbt Cloud hosts the docs for you
- If you want other people to see it, you'll need to host it somewhere (S3, Netlify, etc.)

### What the docs site shows you
- **Model code** — both the Jinja version you wrote and the compiled SQL that actually hits the database
- **Column info** — types, descriptions, anything you added
- **Lineage graph** — a visual DAG showing sources in green, all the way through to your final mart models. You can see exactly what depends on what, and whether a change might break something downstream
- **Project structure** — toggle between a folder view and a database view

It's more of a **technical documentation** tool than a pretty data catalog. It's not going to replace something like Looker or Confluent's data catalog for non-technical stakeholders. But for the people building the models, it's genuinely useful — you can see at a glance what data assets exist, how they connect, and how they work.
