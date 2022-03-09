## Course Project

The goal of this project is to apply everything we learned
in this course and build an end-to-end data pipeline.

### Problem statement

For the project, we will ask you to build a dashboard with two tiles. 

For that, you will need:

* Select a dataset that you're interested in (check [FAQ for a list of datasets](https://docs.google.com/document/d/19bnYs80DwuUimHM65UV3sylsCn2j1vziPOwzBwQrebw/edit#heading=h.1hspwy1mtnp1))
* Create a pipeline for processing this dataset and putting it to a datalake
* Create a pipeline for moving the data from the lake to a data warehouse
* Transform the data in the data warehouse: prepare it for the dashboard
* Create a dashboard

## Data Pipeline 

The pipeline could be stream or batch - this is the first thing you'll need to decide 

You can use anything: 

## Technologies 

You can you anything from the course
If you use something that wasn't covered in the course, 
be sure to explain what the tool does 

## Dashboard

Example of a dashboard: ?


## Peer review criteria

(DRAFT)

* Problem description
* Cloud
    * 0 points: cloud is not used
    * 2 points: cloud is used
    * 4 points: cloud + IaC
* Data ingestion (batch) + Workflow orchestration
    * 0 points: no workflow orch
    * 2 points: partial workflow
    * 4 points: end-to-end pipeline - multiple steps in the dag, uploading data to data lake
* OR Data ingestion (stream)
    * TODO: Discuss with Ankush
* DWH
    * 0 points: no DWH is used
    * 2 points: tables are created, but not optimized (also external tables)
    * 4 points: tables are partitioned and clustered in a way that makes sense for the upstream queries 
* Transformations (dbt, spark, etc)
    * TODO: Discuss with Vic
* Dashboard
    * 0 points: no dashboard
    * 2 points: 1 tile
    * 4 points: 2 tiles 
* Reproducibility
    * 0 points: no readme, no instructions, not clear how to run it
    * 2 points: some things don't run
    * 4 points: easy to reproduce, clear how to run it

24 points max 

## Extra stuff

There are a few extra things that you can do for your project. For 
example, CI/CD and tests. 

This will not be graded. 