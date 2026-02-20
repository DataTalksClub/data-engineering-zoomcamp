# Module 5: Data Platforms

## Overview

In this module, you'll learn about data platforms - tools that help you manage the entire data lifecycle from ingestion to analytics.

We'll use [Bruin](https://getbruin.com/) as an example of a data platform. Bruin puts multiple tools under one platform:

- Data ingestion (extract from sources to your warehouse)
- Data transformation (cleaning, modeling, aggregating)
- Data orchestration (scheduling and dependency management)
- Data quality (built-in checks and validation)
- Metadata management (lineage, documentation)

## Tutorial

Follow the complete hands-on tutorial at:

[Bruin Data Engineering Zoomcamp Template](https://github.com/bruin-data/bruin/tree/main/templates/zoomcamp)

The template is a TODO-based learning exercise — run `bruin init zoomcamp my-taxi-pipeline` and fill in the configuration and code guided by inline comments. The [notes](notes/) contain completed reference implementations.

## Videos

### :movie_camera: 5.1 - Introduction to Bruin

[![](https://markdown-videos-api.jorgenkh.no/youtube/f6vg7lGqZx0)](https://youtu.be/f6vg7lGqZx0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=1)

Introduction to the Bruin data platform: what it is, what a modern data stack looks like (ETL/ELT, orchestration, data quality), and how Bruin brings all of these together into a single project.

- [Notes](notes/01-introduction.md)


### :movie_camera: 5.2 - Getting Started with Bruin

[![](https://markdown-videos-api.jorgenkh.no/youtube/JJwHKSidX_c)](https://youtu.be/JJwHKSidX_c&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=2)

Install Bruin, set up the VS Code/Cursor extension and Bruin MCP, and create a first project using `bruin init`. Walk through environments, connections (DuckDB, Chess.com), pipeline YAML configuration, and running Python, YAML ingestor, and SQL assets.

- [Notes](notes/02-getting-started.md)


### :movie_camera: 5.3 - Building an End-to-End Pipeline with NYC Taxi Data

[![](https://markdown-videos-api.jorgenkh.no/youtube/q0k_iz9kWsI)](https://youtu.be/q0k_iz9kWsI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=3)

Build a full pipeline with a three-layered architecture (ingestion, staging, reports) using NYC taxi data and DuckDB.

- [Notes](notes/03-nyc-taxi-pipeline.md)


### :movie_camera: 5.4 - Using Bruin MCP with AI Agents

[![](https://markdown-videos-api.jorgenkh.no/youtube/224xH7h8OaQ)](https://youtu.be/224xH7h8OaQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=4)

Install the Bruin MCP in Cursor/VS Code and use an AI agent to build the entire NYC taxi pipeline end to end. Query data conversationally, ask questions about pipeline logic, and troubleshoot issues — all through natural language.

- [Notes](notes/04-bruin-mcp.md)


### :movie_camera: 5.5 - Deploying to Bruin Cloud

[![](https://markdown-videos-api.jorgenkh.no/youtube/uBqjLEwF8rc)](https://youtu.be/uBqjLEwF8rc&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=5)

Register for Bruin Cloud, connect your GitHub repository, set up data warehouse connections, deploy and monitor your pipelines with a fully managed infrastructure.

- [Notes](notes/05-bruin-cloud.md)


## Bruin Core Concepts

Short videos covering the fundamental concepts of Bruin: projects, pipelines, assets, variables, and commands.

### :movie_camera: Projects

[![](https://markdown-videos-api.jorgenkh.no/youtube/YWDjnSxbBtY)](https://www.youtube.com/watch?v=YWDjnSxbBtY)

The root directory where you create your Bruin data pipeline. Learn about project initialization, the `.bruin.yml` configuration file, environments, and connections.

- [Notes](notes/06-core-01-projects.md)


### :movie_camera: Pipelines

[![](https://markdown-videos-api.jorgenkh.no/youtube/uzp_DiR4Sok)](https://www.youtube.com/watch?v=uzp_DiR4Sok)

A grouping mechanism for organizing assets based on their execution schedule. Each pipeline has a single schedule and its own configuration file.

- [Notes](notes/06-core-02-pipelines.md)


### :movie_camera: Assets

[![](https://markdown-videos-api.jorgenkh.no/youtube/ZElY5SoqrwI)](https://www.youtube.com/watch?v=ZElY5SoqrwI)

Single files that perform specific tasks, creating or updating tables/views in your database. Covers SQL, Python, and YAML asset types with examples.

- [Notes](notes/06-core-03-assets.md)


### :movie_camera: Variables

[![](https://markdown-videos-api.jorgenkh.no/youtube/XCx0nDmhhxA)](https://www.youtube.com/watch?v=XCx0nDmhhxA)

Dynamic values initialized at each pipeline run. Learn about built-in variables (start_date, end_date) and custom variables for parameterizing your pipelines.

- [Notes](notes/06-core-04-variables.md)


### :movie_camera: Commands

[![](https://markdown-videos-api.jorgenkh.no/youtube/3nykPEs_V7E)](https://www.youtube.com/watch?v=3nykPEs_V7E)

CLI commands for interacting with your Bruin project: `bruin run`, `bruin validate`, `bruin lineage`, and more with practical examples.

- [Notes](notes/06-core-05-commands.md)


## Resources

- [Bruin Documentation](https://getbruin.com/docs)
- [Bruin GitHub Repository](https://github.com/bruin-data/bruin)
- [Bruin MCP (AI Integration)](https://getbruin.com/docs/bruin/getting-started/bruin-mcp)
- [Bruin Cloud](https://getbruin.com/) — managed deployment and monitoring

# Homework

* [2026 Homework](../cohorts/2026/05-data-platforms/homework.md)

# Community notes

<details>
<summary>Did you take notes? You can share them here</summary>

* Add your notes here (above this line)

</details>
