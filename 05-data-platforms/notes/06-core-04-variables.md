# 5.6 - Core Concepts: Variables

🎥 [Bruin Core Concepts | Variables](https://www.youtube.com/watch?v=XCx0nDmhhxA) (6:03)

## What are Variables?

**Variables** are dynamically initialized each time a pipeline run is created. They allow you to parameterize your pipelines and pass dynamic values at runtime.

## Variable Types

### 1. Built-in Variables

Always provided by Bruin automatically:

| Variable | Description |
|----------|-------------|
| `start_date` | Beginning of the scheduled interval |
| `end_date` | End of the scheduled interval |

These dates are determined by the pipeline's schedule:

| Schedule | Start Date | End Date |
|----------|------------|----------|
| **Monthly** | First day of month | Last day of month |
| **Daily** | Start of day | End of day |
| **Hourly** | Start of hour | End of hour |

#### SQL Assets - Jinja Format

In SQL, variables are injected using Jinja templating:

```sql
@bruin.asset(name="staging.monthly_trips", type="sql")
SELECT *
FROM raw.trips
WHERE pickup_date >= '{{ start_date }}'
  AND pickup_date < '{{ end_date }}'
```

Use the **Bruin Render panel** in VS Code to see the compiled query with actual values.

#### Python Assets - Environment Variables

In Python, variables are accessed via environment variables:

```python
import os
from datetime import datetime

@bruin.asset(name="raw.monthly_data", type="python")
def ingest_monthly_data():
    start_date = os.environ['BRUIN_VAR_START_DATE']
    end_date = os.environ['BRUIN_VAR_END_DATE']

    # Parse and use dates to fetch data for specific period
    start = datetime.fromisoformat(start_date)
    end = datetime.fromisoformat(end_date)

    # Loop through months in range
    # ...
```

### 2. Custom Variables

User-defined variables set at the pipeline level.

#### Definition in `pipeline.yml`

```yaml
variables:
  - name: taxi_types
    type: array
    default:
      - "yellow"
```

#### Override at Runtime

Change default values when creating a run:

```bash
bruin run ./pipeline.yml --var taxi_types=["green","fhv"]
```

#### Accessing Custom Variables in Python

```python
import os
import json

@bruin.asset(name="example.asset", type="python")
def example_asset():
    # Custom variables are prefixed with BRUIN_VAR_
    taxi_types_json = os.environ['BRUIN_VAR_TAXI_TYPES']
    taxi_types = json.loads(taxi_types_json)

    # Use the variable in your code
    for taxi_type in taxi_types:
        # Process each taxi type
        pass
```

## VS Code Extension Panel

From the Bruin panel in VS Code/Cursor:

1. **Variable Override** - Set custom variable values before running
2. **Bruin Render** - See how Jinja templates are compiled with actual values
3. **Run Configuration** - Set dates, environment, and variables

## Practical Use Cases

| Use Case | Description |
|----------|-------------|
| **Date-based partitioning** | Extract data for specific time periods |
| **Multi-tenant processing** | Run same pipeline for different customers |
| **Parameterized transformations** | Change logic based on variables |
| **A/B testing** | Test different configurations without code changes |

## Quick Reference

```bash
# Run with custom dates
bruin run ./pipeline.yml --start-date 2020-01-01 --end-date 2020-01-31

# Run with variable override (array)
bruin run ./pipeline.yml --var taxi_types=["green","fhv"]

# Run with variable override (string)
bruin run ./pipeline.yml --var customer_id=12345

# Run with full refresh (affects materialization)
bruin run ./pipeline.yml --full-refresh

# Set end date as exclusive
bruin run ./pipeline.yml --exclusive-end-date
```

## Further Reading

- [Bruin Documentation - Variables](https://getbruin.com/docs/bruin/core-concepts/variables.html)
- [Pipeline Runtime Options](https://getbruin.com/docs/bruin/commands/run.html)
