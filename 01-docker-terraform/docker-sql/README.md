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
3. [Running PostgreSQL with Docker](03-postgres-docker.md) - Dockerizing PostgreSQL database
4. [NY Taxi Dataset and Data Ingestion](04-data-ingestion.md) - Working with real data, pandas, SQLAlchemy
5. [Creating the Data Ingestion Script](05-ingestion-script.md) - Converting notebook to Python script
6. [pgAdmin - Database Management Tool](06-pgadmin.md) - Web-based database management
7. [Dockerizing the Ingestion Script](07-dockerizing-ingestion.md) - Containerizing the pipeline
8. [Docker Compose](08-docker-compose.md) - Multi-container orchestration
9. [SQL Refresher](09-sql-refresher.md) - SQL joins, aggregations, and queries
10. [Cleanup](10-cleanup.md) - Cleaning up Docker resources
