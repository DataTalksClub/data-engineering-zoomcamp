# 5.2 - Getting Started with Bruin

## Installation

Install Bruin CLI:

```bash
curl -LsSf https://getbruin.com/install/cli | sh
bruin version
```

Install the Bruin extension for VS Code or Cursor. This adds a Bruin render panel that lets you run assets and pipelines directly from the IDE.

## Bruin MCP

Bruin provides an MCP (Model Context Protocol) server that you can add to your IDE (Cursor, VS Code) to use AI agents for creating pipelines. Add the Bruin MCP under your IDE settings > Tools and MCP.

## Initializing a project

```bash
bruin init default my-first-pipeline
cd my-first-pipeline
```

This creates a project from a template, initializes git, adds a `.gitignore`, and creates the `bruin.yaml` file.

Bruin requires the project to be git-initialized. The `bruin init` command handles this automatically.

## Project structure

```text
my-first-pipeline/
├── .bruin.yml              # Environment and connection configuration
├── pipeline.yml            # Pipeline name, schedule, default connections
└── assets/
    ├── players.asset.yml   # Ingestr asset (data ingestion)
    ├── player_stats.sql    # SQL asset with quality checks
    └── my_python_asset.py  # Python asset
```

### .bruin.yml

- Stays local only (auto-added to `.gitignore`)
- Never push this to your repo — it contains database connections and secrets
- Defines environments (default, production, staging, etc.)
- Under each environment, define connections (e.g. DuckDB, Chess.com, custom secrets)

```yaml
default_environment: default

environments:
  default:
    connections:
      duckdb:
        - name: duckdb-default
          path: duckdb.db
```

### pipeline.yml

Configures the pipeline: name, schedule, default connection, start date.

```yaml
name: my-pipeline
schedule: daily
start_date: "2022-01-01"
default_connections:
  duckdb: duckdb-default
```

## Asset types

### Python asset

Simplest form: a Python script with a name that prints or processes data. Run from the Bruin panel in your IDE.

### YAML ingestor asset

Uses Bruin's built-in ingestor. Define source connection, destination, and table. Supports many built-in sources and destinations: Redshift, MySQL, Postgres, Motherduck, BigQuery, etc. Automatically creates the destination database/table if it doesn't exist.

### SQL asset

Runs SQL queries against your database. Define dependencies to other assets — when a dependency finishes, this asset runs automatically.

## Intervals and incremental ingestion

- Set `start_date` and `end_date` parameters to ingest data for a specific time range
- Bruin provides these as variables you can inject into your code
- Built-in ingestion assets automatically use the start/end dates

## Dependencies and lineage

- Define dependencies between assets so they run in the correct order
- When the first asset completes, it automatically triggers the next dependent asset
- Bruin builds a lineage graph from these dependencies

## Key CLI commands

| Command | Purpose |
|---------|---------|
| `bruin validate <path>` | Check syntax and dependencies without running |
| `bruin run <path>` | Execute pipeline or individual asset |
| `bruin run --downstream` | Run asset and all downstream dependencies |
| `bruin run --full-refresh` | Truncate and rebuild tables from scratch |
| `bruin lineage <path>` | View asset dependencies |
| `bruin query --connection <conn> --query "..."` | Execute ad-hoc SQL queries |
