# 5.6 - Core Concepts: Pipelines

🎥 [Bruin Core Concepts | Pipelines](https://www.youtube.com/watch?v=uzp_DiR4Sok) (3:13)

## What is a Pipeline?

A **Pipeline** is a grouping mechanism for organizing assets based on their execution schedule and configuration requirements. Within a project, you can have multiple pipelines.

## Key Characteristics

### Single Schedule

Each pipeline has **one schedule** - this is the primary reason to group assets together:
- Assets with the same schedule belong in the same pipeline
- Common schedules: `hourly`, `daily`, `monthly`, or cron expressions

### Pipeline Structure

Each pipeline has its own folder containing a `pipeline.yml` file:

```text
project/
├── .bruin.yml
├── pipelines/
│   ├── nyc-taxi/
│   │   ├── pipeline.yml
│   │   └── assets/
│   └── another-pipeline/
│       ├── pipeline.yml
│       └── assets/
```

## The `pipeline.yml` File

```yaml
name: nyc_taxi
schedule: monthly
start_date: "2019-01-01"
default_connections:
  duckdb: duckdb-default
```

### Configuration Options

| Setting | Description |
|---------|-------------|
| `name` | Pipeline identifier |
| `schedule` | When to run (cron, daily, monthly, etc.) |
| `start_date` | When the pipeline starts being active |
| `default_connections` | Which connections to use |
| `variables` | Custom variables for the pipeline |

### Connection Scoping

Even though connections are defined at the project level (`.bruin.yml`), each pipeline specifies **which connections it uses**.

**Why this matters:**
- In large organizations, different teams may need different credentials
- Prevents unnecessary exposure of secrets
- Only initializes connections needed for the specific pipeline run
- Security isolation between departments

## Quick Reference

```bash
# Validate a pipeline
bruin validate ./pipelines/nyc-taxi/pipeline.yml

# View pipeline lineage
bruin lineage ./pipelines/nyc-taxi/pipeline.yml

# Run the entire pipeline
bruin run ./pipelines/nyc-taxi/pipeline.yml
```

## Further Reading

- [Bruin Documentation - Pipelines](https://getbruin.com/docs/bruin/pipelines/definition.html)
- [Pipeline Configuration Reference](https://getbruin.com/docs/bruin/pipelines/definition.html)
