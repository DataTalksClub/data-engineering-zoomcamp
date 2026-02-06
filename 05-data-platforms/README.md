# Module 5: Data Platforms

## Overview

In this module, you'll learn about data platforms - tools that help you manage the entire data lifecycle from ingestion to analytics.

We'll use [Bruin](https://getbruin.com/) as an example of a data platform. Bruin puts multiple tools under one platform:

- Data ingestion (extract from sources to your warehouse)
- Data transformation (cleaning, modeling, aggregating)
- Data orchestration (scheduling and dependency management)
- Data quality (built-in checks and validation)
- Metadata management (lineage, documentation)

## Getting Started with Bruin

### Installation

```bash
curl -LsSf https://getbruin.com/install/cli | sh
bruin version
```

### Initialize a Project

```bash
bruin init zoomcamp my-pipeline
cd my-pipeline
```

### Key Concepts

- Asset: Any data artifact (table, view, file, ML model, etc.)
- Pipeline: A group of assets executed together in dependency order
- Environment: Named connection configs (e.g., `default`, `production`)
- Connection: Credentials for data sources and destinations

## Tutorial

Follow the complete hands-on tutorial at:

[Bruin Data Engineering Zoomcamp Template](https://github.com/bruin-data/bruin/tree/main/templates/zoomcamp)

This tutorial guides you through building a complete NYC Taxi data pipeline from scratch, including:
- Setting up a Bruin project
- Building ingestion, staging, and reporting layers
- Adding data quality checks
- Using AI assistance (Bruin MCP)
- Deploying to BigQuery

## Resources

- [Bruin Documentation](https://getbruin.com/docs)
- [Bruin GitHub Repository](https://github.com/bruin-data/bruin)
- [Bruin MCP (AI Integration)](https://getbruin.com/docs/bruin/getting-started/bruin-mcp)

## Quick Commands

```bash
# Validate pipeline structure
bruin validate ./pipeline/pipeline.yml

# Run pipeline
bruin run ./pipeline/pipeline.yml --full-refresh

# View lineage
bruin lineage ./pipeline/pipeline.yml

# Query data
bruin query --connection duckdb-default --query "SELECT * FROM ingestion.trips LIMIT 10"
```

# Homework

* [2026 Homework](../cohorts/2026/05-data-platforms/homework.md)

# Community notes

<details>
<summary>Did you take notes? You can share them here</summary>

* Add your notes here (above this line)

</details>
