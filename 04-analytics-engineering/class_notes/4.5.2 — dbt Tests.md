# DE Zoomcamp 4.5.2 — dbt Tests

> 📄 Video: [dbt Tests](https://www.youtube.com/watch?v=bvZ-rJm7uMU)  
> 📄 Official docs: [Data tests](https://docs.getdbt.com/docs/build/data-tests) | [Unit tests](https://docs.getdbt.com/docs/build/unit-tests) | [Model contracts](https://docs.getdbt.com/docs/mesh/govern/model-contracts)

Wrong KPIs in dashboards, bad numbers in reports — there are really only two causes: the underlying data wasn't what you expected, or you messed up the SQL. As an analytics engineer, if you can't tell which one it is, both are technically your fault. Tests are how you stay on top of this proactively. dbt ships with a pretty large suite of testing options, and this video walks through all of them.

---

## 1. Singular tests

The simplest kind of test. You write a plain SQL query, stick it in the `tests/` directory, and that's it — it's now a test.

The logic is straightforward: **if the query returns any rows, the test fails.** You're writing a query that selects for the "bad" cases. Zero rows back means everything checks out.

```sql
-- tests/assert_positive_fare_amount.sql
-- Fare amounts should always be positive

select
    tripid,
    fare_amount
from {{ ref('fct_trips') }}
where fare_amount <= 0
```

These are great for one-off business rules that are very specific to your organization — the kind of thing no generic test is going to cover out of the box.

> 📄 [Singular data tests — docs](https://docs.getdbt.com/docs/build/data-tests#singular-data-tests)

---

## 2. Source freshness tests

These live in your source YAML, not in a separate file. You add a `freshness` block to a source and tell dbt which column indicates when data was last loaded. Then you run `dbt source freshness` and dbt checks whether that timestamp is recent enough.

You can set both `warn_after` and `error_after` thresholds — one to flag it, one to actually fail.

```yaml
version: 2

sources:
  - name: staging
    database: production
    schema: trips_data_all
    tables:
      - name: green_tripdata
        loaded_at_field: lpep_pickup_datetime
        freshness:
          warn_after: {count: 6, period: hour}
          error_after: {count: 12, period: hour}
      
      - name: yellow_tripdata
        loaded_at_field: tpep_pickup_datetime
        freshness:
          warn_after: {count: 6, period: hour}
          error_after: {count: 12, period: hour}
```

Not something you see everywhere, but for pipelines where stale data would cause real problems it's a lifesaver.

> 📄 [Source freshness — docs](https://docs.getdbt.com/reference/resource-properties/freshness)

---

## 3. Generic tests

This is the big one — the most common type of test you'll see in dbt projects. Generic tests are defined in your YAML right alongside your column descriptions. They're parameterized and reusable, so you write the logic once and apply it across as many columns and models as you need.

### The four built-in generic tests

dbt ships with exactly four:

- **unique** — no duplicate values in this column
- **not_null** — no nulls allowed
- **accepted_values** — column values must be within a defined list
- **relationships** — every value in this column must exist in another model (referential integrity)

```yaml
version: 2

models:
  - name: stg_green_tripdata
    description: Staged green taxi data
    columns:
      - name: tripid
        description: Primary key for trips
        tests:
          - unique
          - not_null
      
      - name: vendorid
        tests:
          - not_null
      
      - name: payment_type
        description: Payment method code
        tests:
          - accepted_values:
              values: [1, 2, 3, 4, 5, 6]
      
      - name: pickup_locationid
        description: Taxi zone where trip started
        tests:
          - relationships:
              to: ref('taxi_zone_lookup')
              field: locationid
```

> 📄 [Generic data tests — docs](https://docs.getdbt.com/docs/build/data-tests#generic-data-tests)

### Writing your own custom generic tests

Four tests won't cover everything. You can write your own — they're SQL files that live in `tests/generic/`. The syntax uses Jinja test blocks, and dbt will pick them up and make them available just like the built-ins.

```sql
-- tests/generic/test_positive_values.sql
{% test positive_values(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} < 0

{% endtest %}
```

**Usage in schema.yml:**
```yaml
models:
  - name: fct_trips
    columns:
      - name: fare_amount
        tests:
          - positive_values
      
      - name: trip_distance
        tests:
          - positive_values
```

And here's the thing — you probably don't need to write as many custom tests as you'd expect. The dbt community has already built a ton of them in open-source packages (dbt-utils, dbt-expectations, etc.). Worth checking those before rolling your own.

> 📄 [Writing custom generic tests — docs](https://docs.getdbt.com/best-practices/writing-custom-generic-tests)

---

## 4. Unit tests

Available from dbt v1.8 onwards (released in mid-2024). Unit tests let you test your SQL logic in isolation, without hitting the warehouse with real data.

The idea: you define a small set of mock input rows and the expected output rows. dbt runs your model's SQL against those mocks and checks whether the output matches what you said it should be. This is especially handy for complex logic — rolling windows, regex, edge cases — because you can test for scenarios that haven't even shown up in your real data yet.

```yaml
version: 2

unit_tests:
  - name: test_payment_type_mapping
    description: Test that payment type codes map to correct descriptions
    model: stg_green_tripdata
    given:
      - input: source('staging', 'green_tripdata')
        rows:
          - {tripid: '1', payment_type: 1}
          - {tripid: '2', payment_type: 2}
          - {tripid: '3', payment_type: 5}
    expect:
      rows:
        - {tripid: '1', payment_type_description: 'Credit card'}
        - {tripid: '2', payment_type_description: 'Cash'}
        - {tripid: '3', payment_type_description: 'Unknown'}
```

Unit tests are defined in YAML in your `models/` directory, and currently only support SQL models. Since the inputs are static, there's no reason to run them in production — use them in development and CI.

As of early 2026, unit tests have been available for about 18 months and are seeing increasing adoption, especially for teams with complex transformation logic or strict data quality requirements. They're particularly useful in CI/CD pipelines where you want to catch logic errors before they hit production data.

> 📄 [Unit tests — docs](https://docs.getdbt.com/docs/build/unit-tests)

---

## 5. Model contracts

The last type covered in this video, and a bit different from the others. Model contracts aren't about catching bad data after the fact — they're about **preventing your model from building at all** if it doesn't match a defined shape.

You define the expected columns, data types, and optionally constraints in your YAML. Then you flip on `contract: enforced: true` in the model's config. From that point on, if your model's output doesn't match — wrong column name, wrong type, missing column — dbt will error out before anything gets materialized.

```yaml
version: 2

models:
  - name: fct_trips
    config:
      contract:
        enforced: true
    columns:
      - name: tripid
        data_type: string
        constraints:
          - type: not_null
          - type: unique
      
      - name: pickup_datetime
        data_type: timestamp
        constraints:
          - type: not_null
      
      - name: service_type
        data_type: string
      
      - name: total_amount
        data_type: numeric
```

The idea behind this comes from the concept of **data contracts** — you sit down with your stakeholder, agree on what the output dataset should look like (column names, types, freshness expectations), and the contract enforces that agreement automatically. If someone changes the model in a way that breaks it, they'll know immediately.

> 📄 [Model contracts — docs](https://docs.getdbt.com/docs/mesh/govern/model-contracts)