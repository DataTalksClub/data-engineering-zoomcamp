<p align="center">
  <img width="100%" src="images/architecture/arch_v4_workshops.jpg" alt="Data Engineering Zoomcamp Overview">
</p>

<h1 align="center">
    <strong>Data Engineering Zoomcamp — a free nine-week course covering fundamentals of data engineering</strong>
</h1>

<p align="center">
Learn and practice each part of the data engineering process and apply your acquired knowledge and skills to develop an end-to-end data pipeline from the ground up.
</p>

<p align="center">
<a href="https://airtable.com/shr6oVXeQvSI5HuWD"><img src="https://user-images.githubusercontent.com/875246/185755203-17945fd1-6b64-46f2-8377-1011dcb1a444.png" height="50" /></a>
</p>

<p align="center">
<a href="https://datatalks.club/slack.html">Register on Slack</a> • 
<a href="https://app.slack.com/client/T01ATQK62F8/C01FABYF2RG">Join the #course-data-engineering Slack channel</a> • 
<a href="https://t.me/dezoomcamp">Telegram Announcements Channel</a> • 
<a href="https://www.youtube.com/playlist?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb">Course Playlist</a> • 
<a href="https://docs.google.com/document/d/19bnYs80DwuUimHM65UV3sylsCn2j1vziPOwzBwQrebw/edit?usp=sharing">Frequently Asked Questions (FAQ)</a>
</p>

## How to Take Data Engineering Zoomcamp Course

### 2025 Cohort

- **Start Date**: 13 January 2025
- **Registration Link**: [Sign up here](https://airtable.com/shr6oVXeQvSI5HuWD)
- **Materials**: [Cohort-specific materials](cohorts/2025/)

### Self-Paced Mode

The course materials are open for self-paced learning. Simply follow the suggested syllabus week by week:

1. Start watching the videos.
2. Join the [Slack community](https://datatalks.club/slack.html).
3. Refer to the [FAQ document](https://docs.google.com/document/d/19bnYs80DwuUimHM65UV3sylsCn2j1vziPOwzBwQrebw/edit?usp=sharing) for common issues.

## Syllabus

### Overview

This course consists of modules, workshops, and a project that helps you apply the concepts and tools learned during the course. The syllabus is structured to guide you step-by-step through the world of data engineering.

### Table of Contents

- [Module 1: Containerization and Infrastructure as Code](#module-1-containerization-and-infrastructure-as-code)
- [Module 2: Workflow Orchestration](#module-2-workflow-orchestration)
- [Workshop 1: Data Ingestion](#workshop-1-data-ingestion)
- [Module 3: Data Warehouse](#module-3-data-warehouse)
- [Module 4: Analytics Engineering](#module-4-analytics-engineering)
- [Module 5: Batch Processing](#module-5-batch-processing)
- [Module 6: Streaming](#module-6-streaming)
- [Project](#project)

### Prerequisites

To get the most out of this course, you should feel comfortable with coding and the command line
and know the basics of SQL. Prior experience with Python will be helpful, but you can pick
Python is relatively fast if you have experience with other programming languages.

Prior experience with data engineering is not required.

## Detailed Syllabus

We encourage [Learning in Public](learning-in-public.md)

> **Note:** NYC TLC changed the format of the data we use to parquet.
> In the course we still use the CSV files accessible [here](https://github.com/DataTalksClub/nyc-tlc-data).


### [Module 1: Containerization and Infrastructure as Code](01-docker-terraform/)

* Course overview
* Introduction to GCP
* Docker and docker-compose
* Running Postgres locally with Docker
* Setting up infrastructure on GCP with Terraform
* Preparing the environment for the course
* Homework

[More details](01-docker-terraform/)


### [Module 2: Workflow Orchestration](02-workflow-orchestration/)

* Data Lake
* Workflow orchestration
* Workflow orchestration with Kestra
* Homework

[More details](02-workflow-orchestration/)


### [Workshop 1: Data Ingestion](cohorts/2025/workshops/dlt.md)

* Reading from apis
* Building scalable pipelines
* Normalising data
* Incremental loading
* Homework


[More details](cohorts/2025/workshops/dlt.md)


### [Module 3: Data Warehouse](03-data-warehouse/)

* Data Warehouse
* BigQuery
* Partitioning and clustering
* BigQuery best practices
* Internals of BigQuery
* BigQuery Machine Learning

[More details](03-data-warehouse/)


### [Module 4: Analytics engineering](04-analytics-engineering/)

* Basics of analytics engineering
* dbt (data build tool)
* BigQuery and dbt
* Postgres and dbt
* dbt models
* Testing and documenting
* Deployment to the cloud and locally
* Visualizing the data with google data studio and metabase


[More details](04-analytics-engineering/)


### [Module 5: Batch processing](05-batch/)

* Batch processing
* What is Spark
* Spark Dataframes
* Spark SQL
* Internals: GroupBy and joins

[More details](05-batch/)

### [Module 6: Streaming](06-streaming/)

* Introduction to Kafka
* Schemas (avro)
* Kafka Streams
* Kafka Connect and KSQL

[More details](06-streaming/)

### [Project](projects)

Putting everything we learned to practice

* Week 1 and 2: working on your project
* Week 3: reviewing your peers

[More details](projects)

## Instructors

- [Victoria Perez Mola](https://www.linkedin.com/in/victoriaperezmola/)
- [Alexey Grigorev](https://linkedin.com/in/agrigorev)
- [Michael Shoemaker](https://www.linkedin.com/in/michaelshoemaker1/)
- [Zach Wilson](https://www.linkedin.com/in/eczachly)
- [Will Russell](https://www.linkedin.com/in/wrussell1999/)
- [Anna Geller](https://www.linkedin.com/in/anna-geller-12a86811a/)

Past instructors:

- [Ankush Khanna](https://linkedin.com/in/ankushkhanna2)
- [Sejal Vaidya](https://www.linkedin.com/in/vaidyasejal/)
- [Irem Erturk](https://www.linkedin.com/in/iremerturk/)
- [Luis Oliveira](https://www.linkedin.com/in/lgsoliveira/)


## Asking for help in Slack

The best way to get support is to use [DataTalks.Club's Slack](https://datatalks.club/slack.html). Join the [`#course-data-engineering`](https://app.slack.com/client/T01ATQK62F8/C01FABYF2RG) channel.

To make discussions in Slack more organized:

* Follow [these recommendations](asking-questions.md) when asking for help
* Read the [DataTalks.Club community guidelines](https://datatalks.club/slack/guidelines.html)

## Supporters and partners

Thanks to the course sponsors for making it possible to run this course

<p align="center">
  <a href="https://kestra.io/">
    <img height="120" src="images/kestra.svg">
  </a>
</p>


<p align="center">
  <a href="https://dlthub.com/">
    <img height="90" src="images/dlthub.png">
  </a>
</p>


Do you want to support our course and our community? Please reach out to [alexey@datatalks.club](alexey@datatalks.club)
