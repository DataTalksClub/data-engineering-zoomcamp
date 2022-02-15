# Week 4: Analytics Engineering 
Goal: Transforming the data loaded in DWH to Analytical Views developing a [dbt project](taxi_rides_ny/README.md).
[Slides](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true)

## Prerequisites
We will build a project using dbt and a running data warehouse. 
By this stage of the course you should have already: 
- A running warehouse (BigQuery or postgres) 
- A set of running pipelines ingesting the project dataset (week 3 completed): [Taxi Rides NY dataset](dataset.md)
    * Yellow taxi data - Years 2019 and 2020
    * Green taxi data - Years 2019 and 2020 
    * fhv data - Year 2019. 

_Note: A quick hack has been shared to load that data quicker, check instructions in [week3/extras](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_3_data_warehouse/extras)_
    
### Setting up dbt for using BigQuery (Alternative A - preferred)
You will need to create a dbt cloud account using [this link](https://www.getdbt.com/signup/) and connect to your warehouse [following these instructions](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-setting-up-bigquery-oauth). More detailed instructions in [dbt_cloud_setup.md](dbt_cloud_setup.md)

_Optional_: If you feel more comfortable developing locally you could use a local installation of dbt as well. You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or follow the [dbt with BigQuery on Docker](docker_setup/README.md) guide to setup dbt locally on docker. You will need to install the latest version (1.0) with the BigQuery adapter (dbt-bigquery). 

### Setting up dbt for using Postgres locally (Alternative B)
As an alternative to the cloud, that require to have a cloud database, you will be able to run the project installing dbt locally.
You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or use a docker image from oficial [dbt repo](https://github.com/dbt-labs/dbt/). You will need to install the latest version (1.0) with the postgres adapter (dbt-postgres).
After local installation you will have to set up the connection to PG in the `profiles.yml`, you can find the templates [here](https://docs.getdbt.com/reference/warehouse-profiles/postgres-profile)
## Content
### Introduction to analytics engineering
 * What is analytics engineering?
 * ETL vs ELT 
 * Data modeling concepts (fact and dim tables)

 :movie_camera: [Video](https://www.youtube.com/watch?v=uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=32)

### What is dbt? 
 * Intro to dbt 

 :movie_camera: [Video](https://www.youtube.com/watch?v=4eCouvVOJUw&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=33)
### Starting a dbt project
#### Alternative a: Using BigQuery + dbt cloud
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt cloud setup
 * project.yml

 :movie_camera: [Video](https://www.youtube.com/watch?v=iMxh6s_wL4Q&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=34)
 
#### Alternative b: Using Postgres + dbt core (locally)
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt core local setup
 * profiles.yml
 * project.yml

 :movie_camera: [Video](https://www.youtube.com/watch?v=1HmL63e-vRs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=35)
### Development of dbt models
 * Anatomy of a dbt model: written code vs compiled Sources
 * Materialisations: table, view, incremental, ephemeral  
 * Seeds, sources and ref  
 * Jinja and Macros 
 * Packages 
 * Variables

 :movie_camera: [Video](https://www.youtube.com/watch?v=UVI30Vxzd6c&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=36)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

### Testing and documenting dbt models
 * Tests  
 * Documentation 

 :movie_camera: [Video](https://www.youtube.com/watch?v=UishFmq1hLM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=37)

_Note: This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice_

### Deploying a dbt project
#### Alternative a: Using BigQuery + dbt cloud
 * Deployment: development environment vs production 
 * dbt cloud: scheduler, sources and hosted documentation

 :movie_camera: [Video](https://www.youtube.com/watch?v=rjf6yZNGX8I&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=38)
  
#### Alternative b: Using Postgres + dbt core (locally)
 * Deployment: development environment vs production 
 * dbt cloud: scheduler, sources and hosted documentation

 :movie_camera: [Video](https://www.youtube.com/watch?v=Cs9Od1pcrzM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=39)

### Visualising the transformed data
 * Google data studio 
 * [Metabase (local installation)](https://www.metabase.com/)

 :movie_camera: [Google data studio Video](https://www.youtube.com/watch?v=39nLTs74A3E&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=42) 
 
 :movie_camera: [Metabase Video](https://www.youtube.com/watch?v=BnLkrA7a6gM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=43) 

 
### Advanced knowledge:
 * [Make a model Incremental](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-incremental-models)
 * [Use of tags](https://docs.getdbt.com/reference/resource-configs/tags)
 * [Hooks](https://docs.getdbt.com/docs/building-a-dbt-project/hooks-operations)
 * [Analysis](https://docs.getdbt.com/docs/building-a-dbt-project/analyses)
 * [Snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots)
 * [Exposure](https://docs.getdbt.com/docs/building-a-dbt-project/exposures)
 * [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics)

## Homework 

More information [here](homework.md)

## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/4_analytics.md)
* Add your notes here (above this line)

## Useful links
- [Visualizing data with Metabase course](https://www.metabase.com/learn/visualization/)
- 
