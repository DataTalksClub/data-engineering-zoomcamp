# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Data Engineering Zoomcamp** repository, designed for learning data engineering concepts through hands-on exercises with NYC taxi data. The project includes modules on Docker/Terraform, workflow orchestration, data warehousing, analytics engineering, batch processing, and streaming.

The repository features dual development environments optimized for **Module 4: Analytics Engineering** using either DuckDB (local) or BigQuery (cloud).

## Development Environments

### Devcontainer Setup

The repository uses GitHub Codespaces with isolated workspace environments:

- **DuckDB Environment**: Local processing with pre-baked taxi data
  - Devcontainer: `.devcontainer/duckdb/devcontainer.json`
  - Machine: `standardLinux32gb` (for data baking during build)
  - Workspace: `/home/vscode/homework` (isolated from repo root)

- **BigQuery Environment**: Cloud processing with BigQuery backend
  - Devcontainer: `.devcontainer/bigquery/devcontainer.json`
  - Machine: `basicLinux32gb` (processing is remote)
  - Workspace: `/home/vscode/homework` (isolated from repo root)

### Workspace Isolation

The devcontainer environments use an **isolated workspace pattern**:
- Repository root: `/workspaces/data-engineering-zoomcamp` (read-only reference)
- Working directory: `/home/vscode/homework` (active workspace)
- The `postCreate.sh` scripts promote the dbt project from `04-analytics-engineering/taxi_rides_ny/` to the isolated workspace root

### Python Virtual Environment

All Python packages are pre-installed in `/opt/venv`:
- `dbt-core` with either `dbt-duckdb` or `dbt-bigquery`
- Data processing: `pandas`, `pyarrow`, `requests`
- Cloud tools: `google-cloud-storage`

The virtual environment is automatically activated in every shell.

## dbt Project Architecture

### Project: `taxi_rides_ny`

Location: `04-analytics-engineering/taxi_rides_ny/`

#### Layer Structure

The dbt project follows a medallion-style architecture:

1. **Staging Layer** (`models/staging/`)
   - **Materialization**: Views
   - **Purpose**: Light transformations on raw data
   - **Models**:
     - `stg_yellow_tripdata.sql`: Cleaned yellow taxi trips
     - `stg_green_tripdata.sql`: Cleaned green taxi trips
   - **Sources**: Defined in `sources.yml` with database/schema logic for cross-platform compatibility

2. **Intermediate Layer** (`models/intermediate/`)
   - **Materialization**: Tables
   - **Purpose**: Business logic and data unions
   - **Models**:
     - `int_trips.sql`: Standardized trip structure
     - `int_trips_unioned.sql`: Combined yellow and green trips

3. **Marts Layer** (`models/marts/`)
   - **Materialization**: Tables
   - **Purpose**: Analytical datasets for reporting
   - **Models**:
     - `dim_zones.sql`: Taxi zone dimension
     - `dim_vendors.sql`: Vendor dimension
     - `fct_trips.sql`: Core trip fact table
     - `reporting/fct_monthly_zone_revenue.sql`: Aggregated monthly metrics

### Cross-Platform Compatibility

The dbt project supports both DuckDB and BigQuery through conditional logic:

- **Source definitions** (`sources.yml`): Uses `target.type` checks to switch database/schema names
- **Profiles**: Environment-specific configurations in `.devcontainer/{duckdb,bigquery}/dbt/profiles.yml`
- **Environment variables**: BigQuery setup uses env vars for project ID, dataset, auth method

### Configuration

- **dbt version**: `>=1.7.0`, `<2.0.0`
- **Profile name**: `taxi_rides_ny`
- **Targets**: `dev` (default) and `prod`
- **Dev sampling**: Uses date range vars (`dev_start_date`, `dev_end_date`) for faster development

## Common dbt Commands

All dbt commands should be run from the workspace root (`/home/vscode/homework` in devcontainers, or `04-analytics-engineering/taxi_rides_ny/` in local repo):

```bash
# Test connection and configuration
dbt debug

# Install dependencies from packages.yml
dbt deps

# Build entire project (run models + tests)
dbt build

# Run specific models
dbt run --select stg_yellow_tripdata
dbt run --select staging
dbt run --select +fct_trips  # Include upstream dependencies

# Run tests
dbt test
dbt test --select stg_yellow_tripdata

# Generate and serve documentation
dbt docs generate
dbt docs serve

# Compile SQL (useful for debugging Jinja)
dbt compile --select fct_trips

# Show compiled query results
dbt show --select stg_yellow_tripdata --limit 10
```

## Data Ingestion

### Pre-baked Data (DuckDB)

The DuckDB devcontainer includes pre-baked NYC taxi data at build time:
- **Script**: `.devcontainer/scripts/bake_data.py`
- **Data coverage**: Yellow (2019-2020), Green (2019-2020), FHV (2019)
- **Storage**: `/opt/data/taxi_rides_ny.duckdb` (copied to workspace during `postCreate.sh`)
- **Download source**: `https://d37ci6vzurychx.cloudfront.net/trip-data`

### Manual Data Loading

For local development or BigQuery setup:
- **DuckDB**: `04-analytics-engineering/setup/ingest_taxi_data.py`
- **BigQuery**: `04-analytics-engineering/setup/load_gcs_data.py`
- **Quick setup**: `04-analytics-engineering/setup/prepare_homework_data.sh`

## Deployment Scripts

### Codespace Management

Located in `scripts/`:

- **Deploy Codespaces** (`deploy_codespaces.sh`):
  ```bash
  bash scripts/deploy_codespaces.sh
  ```
  Creates both DuckDB and BigQuery Codespaces non-interactively.

- **Verify Codespace** (`verify_codespace.sh`):
  ```bash
  bash scripts/verify_codespace.sh <codespace-name>
  ```
  Checks workspace isolation, VS Code settings, virtual environment, dbt connectivity, and data loading status.

## Git Workflow

The isolated workspace pattern includes its own Git repository:
- The `/home/vscode/homework` directory is initialized as a fresh Git repo during `postCreate.sh`
- Default branch: `main`
- Initial commit includes promoted dbt project files

When working in the devcontainer, use standard Git commands from `/home/vscode/homework`. Changes are isolated from the main repository.

## Key Architecture Patterns

### Workspace Promotion Logic

The `common_setup.sh` script handles:
1. Repository root detection (handles both standard and edge-case mount paths)
2. Promoting dbt project from `04-analytics-engineering/taxi_rides_ny/` to `/home/vscode/homework/`
3. Copying homework instructions and setup scripts
4. Initializing Git in the isolated workspace
5. Generating VS Code settings from template with environment-specific variables

### Database Schema Strategy

- **DuckDB**: Uses `prod` schema for raw data, `dev` schema for development
- **BigQuery**: Uses separate datasets (`dbt_dev`, `dbt_prod`) configured via env vars
- **Source logic**: Jinja conditionals in `sources.yml` handle schema/database names per target

### Environment Detection

Environment-specific behavior is controlled by:
- `IS_GCP_ENV` environment variable (set in BigQuery devcontainer)
- `target.type` in dbt models (checks for 'bigquery' vs 'duckdb')
- `BAKE_DATA` build arg in Dockerfile (controls pre-baking data during image build)

## Module Structure

The repository is organized by week/module:
- `01-docker-terraform/`: Infrastructure and containerization
- `02-workflow-orchestration/`: Airflow/Prefect pipelines
- `03-data-warehouse/`: BigQuery data warehouse
- `04-analytics-engineering/`: dbt transformations (primary focus)
- `05-batch/`: Spark batch processing
- `06-streaming/`: Kafka streaming

Each module is self-contained with its own README and setup instructions.
