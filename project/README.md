(TBD)

### Project Modules
* `terraform`: Creates project infrastructure (GCS & BigQuery) 
* `docker` config to containerize Postgres, Airflow & Spark
* `airflow`: Workflows (DAGs) for ingestion (extraction) of raw data to Data Lake (GCS) & DWH (BigQuery)
* `dbt`: Workflows to transform DWH data to queryable views
* `spark`: Transformation of Raw Data (GCS) to DWH (BigQuery), orchestrated by Airflow
* `kafka`: ingesting streaming data
