
### Project Modules
1. `terraform`: Creates project infrastructure (GCS & BigQuery)
   
2. Batch:
   * `airflow`: Workflows (DAGs) for ingestion (extraction) of raw data to Data Lake (GCS)
   * `spark`: Transformation of Raw Data (GCS) to DWH (BigQuery), orchestrated by Airflow
   * `Docker` config to containerize Airflow & Spark
    
3. `dbt`: Workflows to transform DWH data to queryable views
   
4. Streaming:
   * `kafka`: ingesting streaming data
    


### Future Enhancements
* Deploy self-hosted Airflow setup on Kubernetes cluster, or use a Managed Airflow (Cloud Composer) service by GCP
