# 5.6 - Core Concepts: Projects

🎥 [Bruin Core Concepts | Projects](https://www.youtube.com/watch?v=YWDjnSxbBtY) (3:03)

## What is a Project?

A **Project** is the root directory where you create your entire Bruin data pipeline. It serves as the foundation for organizing all your data assets, configurations, and connections.

## Project Initialization

The project must be initialized with `bruin init` so the CLI tool can understand the directory structure and navigate files correctly.

```bash
bruin init zoomcamp my-pipeline
cd my-pipeline
```

## The `.bruin.yml` File

Located at the root of your project, this file defines environments, connections, and secrets.

**Important:** This file is always added to `.gitignore` to protect secrets. It stays local only and should never be pushed to your repo.

### Environments

Define different environments for various stages:

```yaml
default_environment: default

environments:
  default:
    connections:
      duckdb:
        - name: duckdb-default
          path: duckdb.db
      motherduck:
        - name: motherduck
          token: <your-token>

  production:
    connections:
      bigquery:
        - name: bq-prod
          project: my-project
          dataset: production
```

**Benefits:**
- Run pipelines locally or on servers without exposing production credentials
- Different teams can have different connection access
- Default to `dev` environment to prevent accidental production runs

### Connection Types

Built-in connections include:
- DuckDB, MotherDuck
- PostgreSQL, MySQL
- BigQuery, Redshift, Snowflake
- Custom connections (for API keys, secrets, etc.)

### Default Environment

Set which environment is used by default:

```yaml
default_environment: dev
```

This ensures pipelines run on development unless explicitly told to use production.

## Quick Reference

```bash
# Initialize a new project
bruin init zoomcamp my-pipeline

# Navigate to your project
cd my-pipeline

# Check project is valid
bruin validate .
```

## Further Reading

- [Bruin Documentation - Projects](https://getbruin.com/docs/bruin/core-concepts/project.html)
- [Bruin GitHub - Templates](https://github.com/bruin-data/bruin/tree/main/templates)
