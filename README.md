# Data Engineering Zoomcamp

dataset: taxi rides NY dataset

Running use cases:

* Building a dashboard 
* ??? 


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
* Data ingestion + preparation + exploration (1 h)
    * data ingestion: 2 step process (20 min)
        * unpack the data
        * convert this raw data to parquet, partition
        * dump to the data to parquet, partition
             * script: downlod the dataset 
             * saving to s3/gcs
             * why parquet is better
        * airflow
        * terraform code for that
    * exploration (20 min)
        * check s3 to see if things are not missing
        * glue crawler in s3 - what's the analog in google? (data fusion?) 
        * using big query / athena to check the data
        * partitioning
* Batch processing (2 h)
    * big query (20 minutes)
         * pointing to a location in google storage (10 min)
         * putting data to big query (10 min)
    * spark 
         * pre-joining data
         * explaining potential of Spark
         * use-case ? 
    * airflow dags
    * terraform code for that
* Analytics engineering (1 h)
    * dbt - models, how they look like
    * dashboards? superset / looker
    * project:
         * deduplication
* Streaming (1-1.5 weeks)
    * kafka 
    * consumer-producer
    * kafka streams, spark streaming
    * streaming analytics ?
    * (pretend rides are coming in a stream)
* Project (2-3 weeks)



