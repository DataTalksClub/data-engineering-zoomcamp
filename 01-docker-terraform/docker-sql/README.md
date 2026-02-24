# Docker and PostgreSQL: Data Engineering Workshop

* Video: [link](https://www.youtube.com/watch?v=lP8xXebHmuE)
* Slides: [link](https://docs.google.com/presentation/d/19pXcInDwBnlvKWCukP5sDoCAb69SPqgIoxJ_0Bikr00/edit?usp=sharing)
* Code: [pipeline/](pipeline/)

In this workshop, we will explore Docker fundamentals and data engineering workflows using Docker containers. This workshop is part of Module 1 of the [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp).

**Data Engineering** is the design and development of systems for collecting, storing and analyzing data at scale.

## Prerequisites

- Basic understanding of Python
- Basic SQL knowledge (helpful but not required)
- Docker and Python installed on your machine
- Git (optional)

## Workshop Contents

1. [Introduction to Docker](01-introduction.md) - What is Docker, why use it, basic commands
2. [Virtual Environments and Data Pipelines](02-virtual-environment.md) - Setting up Python environments with uv
3. [Dockerizing the Pipeline](03-dockerizing-pipeline.md) - Creating a Dockerfile for a simple pipeline
4. [Running PostgreSQL with Docker](04-postgres-docker.md) - Dockerizing PostgreSQL database
5. [NY Taxi Dataset and Data Ingestion](05-data-ingestion.md) - Working with real data, pandas, SQLAlchemy
6. [Creating the Data Ingestion Script](06-ingestion-script.md) - Converting notebook to Python script
7. [pgAdmin - Database Management Tool](07-pgadmin.md) - Web-based database management
8. [Dockerizing the Ingestion Script](08-dockerizing-ingestion.md) - Containerizing the pipeline
9. [Docker Compose](09-docker-compose.md) - Multi-container orchestration
10. [SQL Refresher](10-sql-refresher.md) - SQL joins, aggregations, and queries
11. [Cleanup](11-cleanup.md) - Cleaning up Docker resources
