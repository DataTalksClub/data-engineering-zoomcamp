

### Data Lake (GCS)
  * What is a Data Lake
  * ELT vs. ETL
  * Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)
  * [Video]()
  * [Slides](https://docs.google.com/presentation/d/1RkH-YhBz2apIjYZAxUz2Uks4Pt51-fVWVN9CcH9ckyY/edit?usp=sharing)


### Orchestration (Airflow)
  * What is an Orchestration Pipeline?
  * What is a DAG?
  * [Video]()
    
### Workshop:
  * Setting up Docker with Airflow: -- 15 mins
  * Data ingestion DAG: -- 30 mins 
    * Extraction: Download and unpack the data
    * Pre-processing: Convert this raw data to parquet, partition (raw/yy/mm/dd)
    * Load:
        * Cloud-based, i.e. with GCP (GCS + BigQuery)
           * Raw data in parquet format, to GCS
           * Exploration: BigQuery's External Table, to take a look at the data
        * Local, with Postgres
    
       
### Further Enhancements
    * Transfer Service (AWS -> GCP)
