## Week 2: Data Ingestion

### Data Lake (GCS)

* What is a Data Lake
* ELT vs. ETL
* Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)
* [Video](https://www.youtube.com/watch?v=W3Zm6rjOq70&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* [Slides](https://docs.google.com/presentation/d/1RkH-YhBz2apIjYZAxUz2Uks4Pt51-fVWVN9CcH9ckyY/edit?usp=sharing)


### Introduction to Workflow orchestration

* What is an Orchestration Pipeline?
* What is a DAG?
* [Video](https://www.youtube.com/watch?v=0yK7LXwYeD0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


### Setting up Airflow locally

* Setting up Airflow with Docker-Compose
* [Video](https://www.youtube.com/watch?v=lqDMzReAtrw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* More information in the [airflow folder](airflow)


### Ingesting data to GCP with Airflow

* Extraction: Download and unpack the data
* Pre-processing: Convert this raw data to parquet
* Upload the parquet files to GCS
* Create an external table in BigQuery
* [Video](https://www.youtube.com/watch?v=9ksX9REfL8w&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=19)

### Ingesting data to Local Postgres with Airflow

* Converting the ingestion script for loading data to Postgres to Airflow DAG
* [Video](https://www.youtube.com/watch?v=s2U8MWJH5xA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


### Transfer service (AWS -> GCP)

Moving files from AWS to GCP.

You will need an AWS account for this. This section is optional

* [Video 1](https://www.youtube.com/watch?v=rFOFTfD1uGk&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* [Video 2](https://www.youtube.com/watch?v=VhmmbqpIzeI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)


### Homework 

In the homework, you'll create a few DAGs for processing the NY Taxi data for 2019-2021

More information [here](homework.md)


## Community notes

Did you take notes? You can share them here.

* [Notes from Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/2_data_ingestion.md)
* [Notes from Aaron Wright](https://github.com/ABZ-Aaron/DataEngineerZoomCamp/blob/master/week_2_data_ingestion/README.md)
* [Notes from Abd](https://itnadigital.notion.site/Week-2-Data-Ingestion-ec2d0d36c0664bc4b8be6a554b2765fd)
* [Blog post by Isaac Kargar](https://kargarisaac.github.io/blog/data%20engineering/jupyter/2022/01/25/data-engineering-w2.html)
* Add your notes here
