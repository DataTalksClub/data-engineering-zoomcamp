(TBD)

### Project Modules
* `terraform`: Creates project infrastructure (GCS & BigQuery) 
* `docker` config to containerize Postgres, Airflow & Spark
* `airflow`: Workflows (DAGs) for ingestion (extraction) of raw data to Data Lake (GCS) & DWH (BigQuery)
* `dbt`: Workflows to transform DWH data to queryable views
* `spark`: Transformation of Raw Data (GCS) to DWH (BigQuery), orchestrated by Airflow
* `kafka`: ingesting streaming data

### Objective
The goal of this project is to build an end-to-end data pipeline with … 

### pre-requisites
For that you need to find a data source, build a workflow for consuming it and putting this to lake 

(could be batch - dbt or spark or any alternative technology or stream - kafka or something else)

The data needs to 

1 find a dataset
2 put it to data lake
3 put it to dwh
4 transform the data
5 dashboard with 2 tiles

### output
Problem statement: dashboard 
Stream or batch - decide 
You can choose how you can design your workflow 

### Peer review criteria
