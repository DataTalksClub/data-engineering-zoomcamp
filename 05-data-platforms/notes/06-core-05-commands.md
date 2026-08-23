# 5.6 - Core Concepts: Commands

🎥 [Bruin Core Concepts | Commands](https://www.youtube.com/watch?v=3nykPEs_V7E) (6:46)

## Bruin CLI Commands

Commands are how you interact with your Bruin project - running pipelines, validating configurations, querying data, and more.

## `bruin run` - Execute a Pipeline

Creates a **single execution instance** (a "run") of your pipeline.

### Basic Usage

```bash
bruin run ./pipelines/nyc-taxi/pipeline.yml
```

### Run Scope Options

| Option | Description |
|--------|-------------|
| Entire pipeline | Runs all assets in dependency order |
| Single asset | `--asset staging.trips_summary` |
| With upstream | `--asset X --upstream` - Runs X plus all dependencies |
| With downstream | `--asset X --downstream` - Runs X plus all dependents |

### Common Run Flags

| Flag | Description |
|------|-------------|
| `--start-date DATE` | Set execution start date |
| `--end-date DATE` | Set execution end date |
| `--full-refresh` | Drop and recreate tables (overrides incremental) |
| `--exclusive-end-date` | End date is exclusive (default: inclusive) |
| `--environment ENV` | Use specific environment (dev/prod) |
| `--var KEY=VALUE` | Override custom variables |

### Example Run Commands

```bash
# Simple run
bruin run ./pipelines/nyc-taxi/pipeline.yml

# With date range
bruin run ./pipelines/nyc-taxi/pipeline.yml \
  --start-date 2020-01-01 \
  --end-date 2020-01-31

# Full refresh with variables
bruin run ./pipelines/nyc-taxi/pipeline.yml \
  --full-refresh \
  --var taxi_types=["yellow","green"] \
  --environment default
```

## `bruin validate` - Validate Pipeline

Checks for configuration issues before running:

```bash
bruin validate ./pipelines/nyc-taxi/pipeline.yml
```

**Validates:**
- No circular dependencies in lineage
- Asset definitions are correct
- Connections exist and are properly configured
- No broken references

**Always validate before running!**

## `bruin lineage` - View Dependency Graph

Visualize how assets are connected:

```bash
bruin lineage ./pipelines/nyc-taxi/pipeline.yml
```

Shows upstream and downstream relationships between assets.

## `bruin query` - Query Data

Run ad-hoc queries against your connections:

```bash
bruin query --connection duckdb-default \
  --query "SELECT * FROM ingestion.trips LIMIT 10"
```

## What is a "Run"?

A **run** is a single instance of pipeline execution:
- Has unique start/end times
- May run all assets or a subset
- Has its own variable values
- Creates execution logs and results

## Putting It All Together

The complete Bruin workflow:

```
1. Project (root, initialized)
   └── .bruin.yml (environments, connections)

2. Pipeline (scheduled grouping)
   └── pipeline.yml (schedule, default connection, variables)

3. Assets (the actual work)
   ├── Python (ingestion, processing)
   ├── SQL (transformations)
   └── YAML/Seed (static data)

4. Commands (make it happen)
   ├── bruin run (execute)
   ├── bruin validate (check)
   └── bruin query (inspect)
```

## Quick Reference

```bash
# Initialize new project
bruin init zoomcamp my-pipeline

# Validate before running
bruin validate ./pipeline/pipeline.yml

# Run entire pipeline
bruin run ./pipeline/pipeline.yml

# Run with date range
bruin run ./pipeline/pipeline.yml \
  --start-date 2020-01-01 \
  --end-date 2020-01-31

# Run single asset with downstream
bruin run ./pipeline/pipeline.yml \
  --asset raw.trips \
  --downstream

# View lineage
bruin lineage ./pipeline/pipeline.yml

# Query a table
bruin query --connection duckdb-default \
  --query "SELECT COUNT(*) FROM staging.trips"
```

## Further Reading

- [Bruin Documentation - CLI Reference](https://getbruin.com/docs/bruin/commands/overview.html)
- [Bruin GitHub Repository](https://github.com/bruin-data/bruin)
