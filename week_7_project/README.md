## Course Project

The goal of this project is to apply everything we learned
in this course and build an end-to-end data pipeline.

Remember that to pass the project, you must evaluate 3 peers. If you don't do that, your project can't be considered compelete.  


### Submitting 

#### Project Cohort #2

Project:

* Form: https://forms.gle/JECXB9jYQ1vBXbsw6
* Deadline: 2 May, 22:00 CET

Peer reviewing:

* Peer review assignments: [link](https://docs.google.com/spreadsheets/d/e/2PACX-1vShnv8T4iY_5NA8h0nySIS8Wzr-DZGGigEikIW4ZMSi9HlvhaEB4RhwmepVIuIUGaQHS90r5iHR2YXV/pubhtml?gid=964123374&single=true)
* Form: https://forms.gle/Pb2fBwYLQ3GGFsaK6
* Deadline: 9 May, 22:00 CET


#### Project Cohort #1

Project:

* Form: https://forms.gle/6aeVcEVJipqR2BqC8
* Deadline: 4 April, 22:00 CET

Peer reviewing:

* Peer review assignments: [link](https://docs.google.com/spreadsheets/d/e/2PACX-1vShnv8T4iY_5NA8h0nySIS8Wzr-DZGGigEikIW4ZMSi9HlvhaEB4RhwmepVIuIUGaQHS90r5iHR2YXV/pubhtml)
* Form: https://forms.gle/AZ62bXMp4SGcVUmK7
* Deadline: 11 April, 22:00 CET

Project feedback: [link](https://docs.google.com/spreadsheets/d/e/2PACX-1vRcVCkO-jes5mbPAcikn9X_s2laJ1KhsO8aibHYQxxKqdCUYMVTEJLJQdM8C5aAUWKFl_0SJW4rme7H/pubhtml)


### Problem statement

For the project, we will ask you to build a dashboard with two tiles. 

For that, you will need:

* Select a dataset that you're interested in (see [datasets.md](datasets.md))
* Create a pipeline for processing this dataset and putting it to a datalake
* Create a pipeline for moving the data from the lake to a data warehouse
* Transform the data in the data warehouse: prepare it for the dashboard
* Create a dashboard



## Data Pipeline 

The pipeline could be stream or batch: this is the first thing you'll need to decide 

* If you want to consume data in real-time and put them to data lake - go with stream.
* If you want to run things periodically (e.g. hourly/daily), go with batch


## Technologies 

You don't have to limit yourself to technologies covered in the course. You can use alternatives as well:

* Cloud: AWS, GCP, Azure or others
* Infrastructure as code (IaC): Terraform, Pulumi, Cloud Formation, ...
* Workflow orchestration: Airflow, Prefect, Luigi, ...
* Data Wareshouse: BigQuery, Snowflake, Redshift, ...
* Batch processing: Spark, Flink, AWS Batch, ...
* Stream processing: Kafka, Pulsar, Kinesis, ...

If you use something that wasn't covered in the course, 
be sure to explain what the tool does.

If you're not certain about some tools, ask in Slack.


## Dashboard

You can build a dashboard with any of the tools shown in the course (Data Studio or Metabase) or any other BI tool of your choice. If you do use another tool, please specify and make sure that the dashboard is somehow accessible to your peers. 

Your dashboard should contain at least two tiles, we suggest you include:

- 1 graph that shows the distribution of some categorical data 
- 1 graph that shows the distribution of the data across a temporal line

Make sure that your graph is clear to understand by adding references and titles. 

Example of a dashboard: ![image](https://user-images.githubusercontent.com/4315804/159771458-b924d0c1-91d5-4a8a-8c34-f36c25c31a3c.png)


## Peer review criteria

* Problem description
    * 0 points: Problem is not described
    * 1 point: Problem is described but shortly or not clearly 
    * 2 points: Problem is well described and it's clear what the problem the project solves
* Cloud
    * 0 points: Cloud is not used, things run only locally
    * 2 points: The project is developed on the cloud
    * 4 points: The project is developed on the clound and IaC tools are used
* Data ingestion (choose either batch or stream)
    * Batch / Workflow orchestration
        * 0 points: No workflow orchestration
        * 2 points: Partial workflow orchestration: some steps are orchestrated, some run manually
        * 4 points: End-to-end pipeline: multiple steps in the DAG, uploading data to data lake
    * Stream
        * 0 points: No streaming system (like Kafka, Pulsar, etc)
        * 2 points: A simple pipeline with one consumer and one producer
        * 4 points: Using consumer/producers and streaming technologies (like Kafka streaming, Spark streaming, Flink, etc)
* Data warehouse
    * 0 points: No DWH is used
    * 2 points: Tables are created in DWH, but not optimized
    * 4 points: Tables are partitioned and clustered in a way that makes sense for the upstream queries (with explanation)
* Transformations (dbt, spark, etc)
    * 0 points: No tranformations
    * 2 points: Simple SQL transformation (no dbt or similar tools)
    * 4 points: Tranformations are defined with dbt, Spark or similar technologies
* Dashboard
    * 0 points: No dashboard
    * 2 points: A dashboard with 1 tile
    * 4 points: A dashboard with 2 tiles
* Reproducibility
    * 0 points: No instructions how to run code at all
    * 2 points: Some instructions are there, but they are not complete
    * 4 points: Instructions are clear, it's easy to run the code, and the code works


## Going the extra mile 

If you finish the project and you want to improve it, here are a few things you can do:

* Add tests
* Use make
* Add CI/CD pipeline 

This is not covered in the course and this is entirely optional.

If you plan to use this project as your portfolio project, it'll 
definitely help you to stand out from others.

> **Note**: this part will not be graded. 


Some links to refer to:

* [Unit Tests + CI for Airflow](https://www.astronomer.io/events/recaps/testing-airflow-to-bulletproof-your-code/)
* [CI/CD for Airflow (with Gitlab & GCP state file)](https://engineering.ripple.com/building-ci-cd-with-airflow-gitlab-and-terraform-in-gcp)
* [CI/CD for Airflow (with GitHub and S3 state file)](https://programmaticponderings.com/2021/12/14/devops-for-dataops-building-a-ci-cd-pipeline-for-apache-airflow-dags/)
* [CD for Terraform](https://towardsdatascience.com/git-actions-terraform-for-data-engineers-scientists-gcp-aws-azure-448dc7c60fcc)
* [Spark + Airflow](https://medium.com/doubtnut/github-actions-airflow-for-automating-your-spark-pipeline-c9dff32686b)
