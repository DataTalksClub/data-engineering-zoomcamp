# 5.1 - Introduction to Bruin

## What is Bruin?

Bruin is an end-to-end data platform that combines ingestion, transformations, orchestration, data quality checks, metadata, and lineage into a single tool.

Instead of using five or six different tools configured separately, Bruin lets you have your code logic, configurations, dependencies, and quality checks all in the same place.

## The modern data stack

A typical data stack involves several components:

- Extract/ingest data from third-party sources or databases into a data warehouse or data lake
- Run transformations: clean data, create reports, push results to a warehouse, lake, or third-party application
- Orchestrate: tell different scripts and services when to run, how to run, and how to communicate with each other
- Data quality and governance: ensure accuracy, completeness, and consistency of data before delivering it to consumers

Bruin brings all of these together so you don't need to be a DevOps person, data infrastructure engineer, and data architect just to build a pipeline.

## Learning goals for the tutorial series

- Bruin project structure
- What is a pipeline and what are assets
- How to configure pipelines
- Materialization strategies supported by Bruin
- Lineage and how to build dependencies between assets
- Metadata created automatically and manually
- Parameterizing pipelines with custom variables
