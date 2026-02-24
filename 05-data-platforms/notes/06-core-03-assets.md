# 5.6 - Core Concepts: Assets

🎥 [Bruin Core Concepts | Assets](https://www.youtube.com/watch?v=ZElY5SoqrwI) (6:11)

## What is an Asset?

An **Asset** is a single file that performs a specific task, almost always related to creating or updating a table or view in the destination database.

Each asset file contains two parts:

1. **Definition** (Configuration) - Metadata, name, type, connection
2. **Content** (Code) - The actual SQL, Python, or R code to execute

## Asset Types

| Type | Description | Use Case |
|------|-------------|----------|
| **Python** | Python scripts | Ingestion, data processing, ML models |
| **SQL** | SQL queries | Transformations, aggregations |
| **YAML/Seed** | File-based tables | Reference data, static lookups |
| **R** | R scripts | Statistical analysis, R-specific workflows |

## Asset Naming

The asset name can be:
1. **Explicitly defined** in the decorator
2. **Inferred from file path** (default behavior)

**Convention:** Group assets by schema/dataset:
- `assets/raw/trips_raw.py` → Creates table `raw.trips_raw`
- `assets/staging/trips_summary.sql` → Creates table `staging.trips_summary`

## SQL Asset Example

```sql
@bruin.asset(
    name="staging.trips_summary",
    type="sql",
    connection="duckdb-default",
    materialization="table"
)

SELECT
    pickup_date,
    COUNT(*) as trip_count,
    SUM(fare_amount) as total_fare
FROM raw.trips_raw
WHERE pickup_date >= '{{ start_date }}'
  AND pickup_date < '{{ end_date }}'
GROUP BY pickup_date
```

### Materialization Strategies

| Strategy | Behavior |
|----------|----------|
| `table` | Recreates the table on each run |
| `view` | Creates a view (no data stored) |
| `insert` | Appends new data to existing table |
| `incremental` | Smart merge based on key columns |

## Python Asset Example (Ingestion)

```python
@bruin.asset(
    name="raw.trips_raw",
    type="python",
    connection="duckdb-default"
)
def ingest_trips():
    import requests
    import pandas as pd

    # Connect to API, fetch data
    response = requests.get("https://api.example.com/trips")
    data = response.json()

    # Return pandas DataFrame
    # Bruin handles materialization to database
    return pd.DataFrame(data)
```

## YAML/Seed Asset Example

```yaml
@bruin.asset(
    name="lookup.taxi_types",
    type="seed",
    connection="duckdb-default"
)

path: reference_data/taxi_types.csv
```

Simply loads a local CSV file and creates a table in the destination database.

## Lineage & Dependencies

Assets automatically define dependencies based on what they read:

- If Asset B reads from Asset A's table, **B depends on A**
- Visualized in VS Code extension
- Used for execution ordering during runs

```sql
-- This asset depends on raw.trips_raw
@bruin.asset(name="staging.trips_summary", type="sql")
SELECT * FROM raw.trips_raw  -- Creates dependency
```

## Quick Reference

```bash
# Run a specific asset
bruin run ./pipeline.yml --asset raw.trips_raw

# Run asset with all downstream dependencies
bruin run ./pipeline.yml --asset raw.trips_raw --downstream

# Run asset with all upstream dependencies
bruin run ./pipeline.yml --asset staging.trips_summary --upstream

# View lineage for an asset
bruin lineage ./pipeline.yml --asset raw.trips_raw
```

## Further Reading

- [Bruin Documentation - Assets](https://getbruin.com/docs/bruin/assets/definition-schema.html)
- [Materialization Strategies](https://getbruin.com/docs/bruin/assets/materialization.html)
