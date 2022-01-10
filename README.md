# Data Engineering Zoomcamp

- **Start**: 17 January 2022
- **Registration link**: https://airtable.com/shr6oVXeQvSI5HuWD
- Register in [DataTalks.Club's Slack](https://datatalks.club/slack.html)
- Join the [`#course-data-engineering`](https://app.slack.com/client/T01ATQK62F8/C01FABYF2RG) channel



## Syllabus

> **Note**: This is preliminary and may change

### [Week 1: Introduction & Prerequisites](week_1_basics_n_setup)

* SQL
* Docker and Terraform
* [Dataset: Taxi Rides NY dataset](dataset.md)
* Taking a first look at the data 

Duration: 1h


### [Week 2: Data ingestion + data lake + exploration](week_2_data_ingestion)

* Data ingestion: 2 step process
    * Download and unpack the data
    * Save the data to GCS
* Data Lake (20 min)
    * What is data lake?
    * Convert this raw data to parquet, partition
    * Alternatives to gcs (S3/HDFS)
* Exploration (20 min)
    * Taking a look at the data
    * Data fusion => Glue crawler equivalent
    * Partitioning
    * Google data studio -> Dashboard
* Terraform code for that

Duration: 1h


### [Week 3 & 4: Batch processing (BigQuery, Spark and Airflow)](week_3_4_batch_processing)

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
    * use-case
    * What else is out there  (Flink) (5 mins)
* Orchestration tool (airflow) (30 minutes)
    * Basic: Airflow dags (10 mins)
    * Big query on airflow (10 mins)
    * Spark on airflow (10 mins)
* Terraform code for that

Duration: 2h 


### Week 5: [Analytics engineering](week_5_analytics_engineering)

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
    * DBT cloud: scheduler, sources and data catalog (Airflow)
* Extra knowledge:
    * DBT cli (local)

Duration: 1.5-2h    

### [Week 6: Streaming](week_6_stream_processing)

* Basics
    * What is Kafka
    * Internals of Kafka, broker
    * Partitoning of Kafka topic
    * Replication of Kafka topic
* Consumer-producer
* Streaming
    * Kafka streams
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


### [Week 7, 8 & 9: Project](project)

* Putting everything we learned to practice

Duration: 2-3 weeks


## Architecture diagram

<img src="images/architecture/arch_1.jpg"/>

## Prerequisites

To get most out of this course, you should feel comfortable with coding and command line,
and know the basics of SQL. Prior experience with Python will be helpful, but you can pick 
Python relatively fast if you have experience with other programming languages.

Prior experience with data engineering is not required.



## Instructors

- Ankush Khanna (https://linkedin.com/in/ankushkhanna2)
- Sejal Vaidya (https://linkedin.com/in/vaidyasejal)
- Victoria Perez Mola (https://www.linkedin.com/in/victoriaperezmola/)
- Alexey Grigorev (https://linkedin.com/in/agrigorev)


## FAQ

* **Q**: I registered, but haven't received a confirmation email. Is it normal?
  **A**: Yes, it's normal. It's not automated. But you will receive an email eventually 
* **Q**: At what time of the day will it happen?
  **A**: Office hours will happen on Mondays at 17:00 CET. But everything will be recorded, so you can watch it whenever it's convenient for you
* **Q**: Will there be a certificate?
  **A**: Yes, if you complete the project
* **Q**: I'm 100% not sure I'll be able to attend. Can I still sign up?
  **A**: Yes, please do! You'll receive all the updates and then you can watch the course at your own pace. 
* **Q**: Do you plan to run a ML engineering course as well? **A**: Glad you asked. [We do](https://github.com/alexeygrigorev/mlbookcamp-code/tree/master/course-zoomcamp) :)
