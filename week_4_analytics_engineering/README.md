# Week 4: Analytics Engineering 
Goal: Transforming the data loaded in DWH to Analytical Views developing a [dbt project](taxi_rides_ny/README.md).
[Slides](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true)

## Prerequisites
We will build a project using dbt and a running data warehouse. 
By this stage of the course you should have already: 
- A running warehouse (BigQuery or postgres) 
- A set of running pipelines ingesting the project dataset (week 3 completed): [Taxi Rides NY dataset](dataset.md)
### Setting up dbt for using BigQuery (Alternative A - preferred)
You will need to create a dbt cloud account using [this link](https://www.getdbt.com/signup/) and connect to your warehouse [following these instructions](https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-setting-up-bigquery-oauth). More detailed instructions in [dbt_cloud_setup.md](dbt_cloud_setup.md)

_Optional_: If you feel more comfortable developing locally you could use a local installation of dbt as well. You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or use a docker image from oficial [dbt repo](https://github.com/dbt-labs/dbt/). You will need to install the latest version (1.0) with the BigQuery adapter (dbt-bigquery).
After local installation you will have to set up the connection to BQ in the `profiles.yml`, you can find the templates [here](https://docs.getdbt.com/reference/warehouse-profiles/bigquery-profile)

### Setting up dbt for using Postgres locally (Alternative B)
As an alternative to the cloud, that require to have a cloud database, you will be able to run the project installing dbt locally.
You can follow the [official dbt documentation](https://docs.getdbt.com/dbt-cli/installation) or use a docker image from oficial [dbt repo](https://github.com/dbt-labs/dbt/). You will need to install the latest version (1.0) with the postgres adapter (dbt-postgres).
After local installation you will have to set up the connection to PG in the `profiles.yml`, you can find the templates [here](https://docs.getdbt.com/reference/warehouse-profiles/postgres-profile
## Content
### Introduction to analytics engineering (15 mins)
 * What is analytics engineering?
 * ETL vs ELT 
 * Data modeling concepts (fact and dim tables)

 :movie_camera: Video

### What is dbt? 
 * Intro to dbt 

 :movie_camera:
### Starting a dbt project
#### Alternative a: Using BigQuery + dbt cloud
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt cloud setup
 * project.yml

 :movie_camera: Video
 
#### Alternative b: Using Postgres + dbt core (locally)
 * Starting a new project with dbt init (dbt cloud and core)
 * dbt core local setup
 * profiles.yml
 * project.yml

 :movie_camera: Video
### Development of dbt models
 * Anatomy of a dbt model: written code vs compiled Sources
 * Materialisations: table, view, incremental, ephemeral  
 * Seeds, sources and ref  
 * Jinja and Macros 
 * Packages 
 * Variables

 :movie_camera: Video

### Testing and documenting dbt models
 * Tests  
 * Documentation 

  :movie_camera: Video

### Deploying a dbt project
 * Deployment: local development vs production 
 * dbt cloud: scheduler, sources and hosted documentation

  :movie_camera: Video

### Visualising the transformed data
 * Google data studio -> Dashboard

 :movie_camera: Video
### Advanced knowledge:
 * Make a model Incremental 
 * Use of tags 
 * Snapshots

## Homework 

More information [here](homework.md)

## Community notes

Did you take notes? You can share them here.

