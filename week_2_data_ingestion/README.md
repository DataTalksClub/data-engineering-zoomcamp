

### Data Lake (GCS)
  * What is a Data Lake
  * ELT vs. ETL
  * Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)
  * [Video](https://www.youtube.com/watch?v=W3Zm6rjOq70&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=14)
  * [Slides](https://docs.google.com/presentation/d/1RkH-YhBz2apIjYZAxUz2Uks4Pt51-fVWVN9CcH9ckyY/edit?usp=sharing)


### Orchestration (Airflow)
  * What is an Orchestration Pipeline?
  * What is a DAG?
  * [Video](https://www.youtube.com/watch?v=0yK7LXwYeD0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=15)
    
### Workshop:
  * Setting up Docker with Airflow: -- 15 mins
    * [Video](https://www.youtube.com/watch?v=lqDMzReAtrw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=17) 
  * Data ingestion DAG: -- 30 mins 
    * Extraction: Download and unpack the data
    * Pre-processing: Convert this raw data to parquet, partition (raw/yy/mm/dd)
    * Load:
        * Cloud-based, i.e. with GCP (GCS + BigQuery)
           * Raw data in parquet format, to GCS
           * Exploration: BigQuery's External Table, to take a look at the data
        * Local, with Postgres
           * (TBD)
    * [Video - Ready / To be uploaded]()
    
       
### Further Enhancements
  * Transfer Service (AWS -> GCP)
    * [Video 1](https://www.youtube.com/watch?v=rFOFTfD1uGk&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=16)
    * [Video 2](https://www.youtube.com/watch?v=VhmmbqpIzeI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=17)   

## Community notes

Did you take notes? You can share them here.

* [Notes from Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/2_data_ingestion.md)
* Add your notes here