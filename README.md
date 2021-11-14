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

Plan:

* Introduction & prerequisites (1 h)
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
* Data ingestion + data lake + exploration (1 h)
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
* Batch processing (2 h)
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
* Analytics engineering (1 h)
    * dbt - models, how they look like
    * dashboards? superset / looker
    * project:
         * deduplication
* Streaming (1-1.5 weeks)
    * What is Kafka, internals of Kafka, broker
    * Partitoning of Kafka topic
    * Replication of Kafka topic
    * consumer-producer
    * kafka streams, spark streaming-Transformation
    * Kafka connect
    * KSQLDB?
    * streaming analytics ???
    * (pretend rides are coming in a stream)
    * Alternatives (PubSub/Pulsar)
* Upcoming buzzwords (10 mins)
    * Delta Lake/Lakehouse
        * Databricks
        * Apache iceberg
        * Apache hudi
    * Data mesh
* Project (2-3 weeks)



