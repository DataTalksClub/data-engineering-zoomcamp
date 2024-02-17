# All lessons in one folder

Copied files used in module-02 onwards so lessons can have a central location for files required to do practices and homework.

- secrets
- maze-zoomcamp
- mage-data
- docker files

## Module-01

More in-depth walkthrough and notes in [cohorts-2024-module-01](../01-docker-terraform/) folder.

### Pre-requisites

See [environment.yml](../../../environment.yml) for python packages to install

- debit/credit card info
  - GCP account
- github account
- env seup with
  - git
  - IDE
  - docker
  - python
  - postgres
  - terraform

### datasets

- lesson: yellow 2021-01, csv.gz file
- homework: green 2019-09, csv.gz files

### goals

- understand docker, images vs containers, volumes, networks
- dockerfile vs docker-compose.yaml
- using images to spin up containers to ingest 1-month's worth of data in a single file
- terraform concepts: init-plan-apply-destroy, hardcoding vs variables
- using terraform to create our IaaS GCP bucket to store our datasets

## Module-02 

### Pre-requisites

- mage-ai if not using docker image, otherwise no new installs
- starter mage repo

### datasets

- lesson: yellow_tripdata_2021-01, csv.gz file
- homework: green 2020 (months 10, 11, 12), csv.gz files

### goals

- use mage-ai and GCP to perform ETL
- load dataset to gcs  
- then partition and load to BQ and 
- optionally deploy to Cloud Run 

### homework

See [homework-02](../02-workflow-orchestration/homework-02.ipynb)

## Workshop-01

performing our etl/elt with dlthub for more reliable ingestion via chunking and/or streaming of data
- page-by-page
- event-by-event
without getting hit by astronomical fees due to API-abuse or halted by rate-limits

### Pre-requisites

- dlt installs with anything extra like 'dlt[duckdb]'

## Module-03 

### Pre-requisites

- no new installs
- starter notebook(s) on colab

### datasets

- lesson: none specified, just using BQ's built-in datasets and extras snippets
  - or upload using the script in /extras
- homework: green 2022 parquet files
  - must be from nyc.gov source in parquet format
  - DTC source does not have 2022 data, ends at 2021-07 and only for csv.gz
  
### goals

- use mage-ai to load the year's parquet data to gcs, or script
- from this "external" table, create UNpartition table into BQ
- partition to answer qn4
- cluster to answer qn4
- try:
  - use dlt in mage to utilize generators and pipelines from workshop
  - use utils folder in mage
  - use secrets in mage
- deploy? use git versioning (can only pull? need verification. Experiment first.) 

### lesson practicals

- created this README
- see what datasets are available; explore for capstone

[source](https://mageai.slack.com/archives/C05NYC4DADT/p1704817959660529?thread_ts=1704817635.872979&cid=C05NYC4DADT)
```python
import importlib
module = importlib.import_module("utils.functions.dummy")
module.dummy_function()
```

### homework

See [homework-03](../03-data-warehouse/homework.md)

## Module-04 

### Pre-requisites

- dbt account on cloud.getdbt.com
- dbt installs locally if not using cloud
- starter dbt project

### datasets
- lesson: 
- homework:
  * Yellow taxi data - Years 2019 and 2020
  * Green taxi data - Years 2019 and 2020 
  * fhv data - Year 2019

See [homework-04](../04-analytics-engineering/homework.md)

### goals



## Module-05 datasets

### datasets
### goals

## Module-06 datasets

### datasets
### goals