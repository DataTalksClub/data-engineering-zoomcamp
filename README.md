# Data Engineering Zoomcamp

Registration link: https://airtable.com/shr6oVXeQvSI5HuWD

[dataset: taxi rides NY dataset](dataset.md)

Running use cases:

* Building a dashboard 
* ??? 

TODO:

* Make a architecture diagram for the entire zoomcamp


Platform:

* Google cloud - they $300 have free credits =)  


## Syllabus

## Introduction & Prerequisites

* SQL
    * should be a pre-requisite? - assume basic understanding
    * advanced skills: window functions?
    * they have to get a lot of practice
* docker
    * what needs to be installed
    * use cases: airflow, dbt, aws batch, spark 
* terraform
    * general overview / introduction
    * syntax and use cases

Duration: 1h

### Data ingestion + data lake + exploration

* Data ingestion: 2 step process (20 min)
    * Unpack the data
        * Script: downlod the dataset 
        * Saving to gcs
* Data Lake (20 min)
    * What is data lake?
    * convert this raw data to parquet, partition
        * Saving to gcs
        * Why parquet is better
        * Partitoning strategy
    * Alternatives to gcs (S3/HDFS)
* Exploration (20 min)
    * check gcs to see if things are not missing
    * using big query / athena to check the data
    * Data fusion => Glue crawler equivalent
    * Partitioning
    * Google data studio -> Dashboard
* Terraform code for that

Duration: 1h


### Batch processing

* Data warehouse (BigQuery) (25 minutes)
    * What is a data warehouse solution
    * What is big query, why is so fast  (5 min)
    * Partitoning and clustering (10 min)
    * Pointing to a location in google storage (5 min)
    * Putting data to big query (5 min)
    * Alternatives (Snowflake/Redshift)
* Distributed processing (Spark) (40 + ? minutes)
    * What is Spark, spark cluster (5 mins)
    * Explaining potential of Spark (10 mins)
    * What is broadcast variables, partitioning, shuffle (10 mins)
    * Pre-joining data (10 mins)
    * use-case ?
    * What else is out there  (Flink) (5 mins)
* Orchestration tool (airflow) (30 minutes)
    * Basic: Airflow dags (10 mins)
    * Big query on airflow (10 mins)
    * Spark on airflow (10 mins)
* ?Data skew?
* Terraform code for that

Duration: 2h 


### Analytics engineering

* Basics (15 mins)
    * What is DBT?
    * ETL vs ELT 
    * Data modeling
    * DBT fit of the tool in the tech stack
* Usage (Combination of coding + theory) (1:30-1:45 mins)
    * Anatomy of a dbt model: written code vs compiled Sources
    * Materialisations: table, view, incremental, ephemeral  
    * Seeds 
    * Sources and ref  
    * Jinja and Macros 
    * Tests  
    * Documentation 
    * Packages 
    * Deployment: local development vs production 
    * Dbt cloud: scheduler, sources and data catalog (Airflow)
* Extra knowledge:
    * DBT cli (local)

Duration: 1.5-2h    

### Streaming

* Basics
    * What is Kafka
    *  internals of Kafka, broker
    * Partitoning of Kafka topic
    * Replication of Kafka topic
* Consumer-producer
* Streaming
    * kafka streams, 
    * spark streaming-Transformation
* Kafka connect
* KSQLDB?
* streaming analytics ???
* (pretend rides are coming in a stream)
* Alternatives (PubSub/Pulsar)

Duration: 1-1.5h

### Upcoming buzzwords

* Delta Lake/Lakehouse
    * Databricks
    * Apache iceberg
    * Apache hudi
* Data mesh

Duration: 10 mins

### Project

* Putting everything we learned to practice

Duration: 2-3 weeks



