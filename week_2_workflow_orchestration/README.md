## Week 2: Workflow Orchestration

> If you're looking for Airflow videos from the 2022 edition,
> check the [2022 cohort folder](../cohorts/2022/week_2_data_ingestion/).


### Data Lake (GCS)

* What is a Data Lake
* ELT vs. ETL
* Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)
* [Video](https://www.youtube.com/watch?v=W3Zm6rjOq70&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* [Slides](https://docs.google.com/presentation/d/1RkH-YhBz2apIjYZAxUz2Uks4Pt51-fVWVN9CcH9ckyY/edit?usp=sharing)


### 1. Introduction to Workflow orchestration

* What is orchestration?
* Workflow orchestrators vs. other types of orchestrators
* Core features of a workflow orchestration tool
* Different types of workflow orchestration tools that currently exist 

:movie_camera: [Video](https://www.youtube.com/watch?v=8oLs6pzHp68&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


### 2. Introduction to Prefect concepts

* What is Prefect?
* Installing Prefect
* Prefect flow
* Creating an ETL
* Prefect task
* Blocks and collections
* Orion UI

:movie_camera: [Video](https://www.youtube.com/watch?v=cdtN6dhp708&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

### 3. ETL with GCP & Prefect

* Flow 1: Putting data to Google Cloud Storage 

:movie_camera: [Video](https://www.youtube.com/watch?v=W-rMz_2GwqQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


### 4. From Google Cloud Storage to Big Query

* Flow 2: From GCS to BigQuery

:movie_camera: [Video](https://www.youtube.com/watch?v=Cx5jt-V5sgE&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

### 5. Parametrizing Flow & Deployments 

* Parametrizing the script from your flow
* Parameter validation with Pydantic
* Creating a deployment locally
* Setting up Prefect Agent
* Running the flow
* Notifications

:movie_camera: [Video](https://www.youtube.com/watch?v=QrDxPjX10iw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

### 6. Schedules & Docker Storage with Infrastructure

* Scheduling a deployment
* Flow code storage
* Running tasks in Docker

:movie_camera: [Video](https://www.youtube.com/watch?v=psNSzqTsi-s&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

### 7. Prefect Cloud and Additional Resources 


* Using Prefect Cloud instead of local Prefect
* Workspaces
* Running flows on GCP

:movie_camera: [Video](https://www.youtube.com/watch?v=gGC23ZK7lr8&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)

* [Prefect docs](https://docs.prefect.io/)
* [Pefect Discourse](https://discourse.prefect.io/)
* [Prefect Cloud](https://app.prefect.cloud/)
* [Prefect Slack](https://prefect-community.slack.com)

### Code repository

[Code from videos](https://github.com/discdiver/prefect-zoomcamp) (with a few minor enhancements)

### Homework 

To be linked here by Jan. 30


## Community notes

Did you take notes? You can share them here.

* [Blog by Marcos Torregrosa (Prefect)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-2/)
* [Notes from Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week2)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week2.md)
* [Notes by Candace Williams](https://github.com/teacherc/de_zoomcamp_candace2023/blob/main/week_2/week2_notes.md)
* Add your notes here (above this line)


### 2022 notes 

Most of these notes are about Airflow, but you might find them useful.

* [Notes from Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/2_data_ingestion.md)
* [Notes from Aaron Wright](https://github.com/ABZ-Aaron/DataEngineerZoomCamp/blob/master/week_2_data_ingestion/README.md)
* [Notes from Abd](https://itnadigital.notion.site/Week-2-Data-Ingestion-ec2d0d36c0664bc4b8be6a554b2765fd)
* [Blog post by Isaac Kargar](https://kargarisaac.github.io/blog/data%20engineering/jupyter/2022/01/25/data-engineering-w2.html)
* [Blog, notes, walkthroughs by Sandy Behrens](https://learningdataengineering540969211.wordpress.com/2022/01/30/week-2-de-zoomcamp-2-3-2-ingesting-data-to-gcp-with-airflow/)
