> If you're looking for Airflow videos from the 2022 edition,
> check the [2022 cohort folder](../cohorts/2022/week_2_data_ingestion/). <br>
> If you're looking for Prefect videos from the 2023 edition,
> check the [2023 cohort folder](../cohorts/2023/week_2_data_ingestion/).

# Week 2: Workflow Orchestration

Welcome to Week 2 of the Data Engineering Zoomcamp! 🚀😤 This week, we'll be covering workflow orchestration with Mage.

Mage is an open-source, hybrid framework for transforming and integrating data. ✨

In this module, you'll learn how to use the Mage platform to author and share _magical_ data pipelines. This will all be covered in the course, but if you'd like to learn a bit more about Mage, check out our docs [here](https://docs.mage.ai/introduction/overview). 

You can find this week's videos and resources in the [Course Resources](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#-course-resources) section below. 

The first two videos are more conceptual and introductory. In the second, we'll dive into configuring Mage from our [Getting Started Repo](https://github.com/mage-ai/mage-zoomcamp).

## Course Outline


[2.2.1 - 📯 Intro to Orchestration](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#221----intro-to-orchestration)

[2.2.2 - 🧙‍♂️ Intro to Mage](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#222---%EF%B8%8F-intro-to-mage)

[2.2.3 - 🐘 ETL: API to Postgres](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#223----etl-api-to-postgres)

[2.2.4 - 🤓 ETL: API to GCS](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#224----etl-api-to-gcs)

[2.2.5 - 🔍 ETL: GCS to BigQuery](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#225----etl-gcs-to-bigquery)

[2.2.6 - 👨‍💻 Parameterized Execution](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#226----parameterized-execution)

[2.2.7 - 🤖 Deployment (Optional)](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#227----deployment-optional)

[2.2.8 - 🧱 Advanced Blocks (Optional)](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#228----advanced-blocks-optional)

[2.2.9 - 🗒️ Homework](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#229---%EF%B8%8F-homework)

[2.2.10 - 👣 Next Steps](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#2210----next-steps)

## 🌊 Data Lake (GCS)

This course uses Google Cloud Storage (GCS) as a data lake. If you're not familiar with the concept of a data lake, the following may be helpful:
* [Video](https://www.youtube.com/watch?v=W3Zm6rjOq70&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* [Slides](https://docs.google.com/presentation/d/1RkH-YhBz2apIjYZAxUz2Uks4Pt51-fVWVN9CcH9ckyY/edit?usp=sharing)

This video covers the basics of data lakes and data warehouses, including:
* What is a Data Lake?
* ELT vs. ETL?
* Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)git add .

## 📕 Course Resources

### 2.2.1 - 📯 Intro to Orchestration

In this section, we'll cover the basics of workflow orchestration. We'll discuss what it is, why it's important, and how it can be used to build data pipelines.

Videos
- What is Orchestration?

Resources
- [Slides](https://docs.google.com/presentation/d/17zSxG5Z-tidmgY-9l7Al1cPmz4Slh4VPK6o2sryFYvw/)

### 2.2.2 - 🧙‍♂️ Intro to Mage

In this section, we'll introduce the Mage platform. We'll cover what makes Mage different from other orchestrators, the fundamental concepts behind Mage, and how to get started. To cap it off, we'll spin Mage up via Docker 🐳 and run a simple pipeline.

Videos
- What is Mage?
- Configuring Mage
- A Simple Pipeline

Resources
- [Getting Started Repo](https://github.com/mage-ai/mage-zoomcamp)
- [Slides](https://docs.google.com/presentation/d/1y_5p3sxr6Xh1RqE6N8o2280gUzAdiic2hPhYUUD6l88/)

### 2.2.3 - 🐘 ETL: API to Postgres

Hooray! Mage is up and running. Now, let's build a _real_ pipeline. In this section, we'll build a simple ETL pipeline that loads data from an API into a Postgres database. Our database will be built using Docker— it will be running locally, but it's the same as if it were running in the cloud.

Videos
- Configuring Postgres
- Writing an ETL Pipeline

Resources
- [Taxi Dataset](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz)
- [Sample loading block](https://github.com/mage-ai/mage-zoomcamp/blob/solutions/magic-zoomcamp/data_loaders/load_nyc_taxi_data.py)

### 2.2.4 - 🤓 ETL: API to GCS

Ok, so we've written data _locally_ to a database, but what about the cloud? In this tutorial, we'll walk through the process of using Mage to extract, transform, and load data from an API to Google Cloud Storage (GCS). 

We'll cover both writing _partitioned_ and _unpartitioned_ data to GCS and discuss _why_ you might want to do one over the other. Many data teams start with extracting data from a source and writing it to a data lake _before_ loading it to a structured data source, like a database.

Videos
- Configuring GCP
- Writing an ETL Pipeline

Resources
- [DTC Zoomcamp GCP Setup](../week_1_basics_n_setup/1_terraform_gcp/2_gcp_overview.md)

### 2.2.5 - 🔍 ETL: GCS to BigQuery

Now that we've written data to GCS, let's load it into BigQuery. In this section, we'll walk through the process of using Mage to load our data from GCS to BigQuery. This closely mirrors a very common data engineering workflow: loading data from a data lake into a data warehouse.

Videos
- Writing an ETL Pipeline

### 2.2.6 - 👨‍💻 Parameterized Execution

By now you're familiar with building pipelines, but what about adding parameters? In this video, we'll discuss some built-in runtime variables that exist in Mage and show you how to define your own! We'll also cover how to use these variables to parameterize your pipelines. 

Videos
- Parameterized Execution

Resources
- [Mage Variables Overview](https://docs.mage.ai/development/variables/overview)
- [Mage Runtime Variables](https://docs.mage.ai/getting-started/runtime-variable)

### 2.2.7 - 🤖 Deployment (Optional)

In this section, we'll cover deploying Mage using Terraform and Google Cloud. This section is optional— it's not *necessary* to learn Mage, but it might be helpful if you're interested in creating a fully deployed project. If you're using Mage in your final project, you'll need to deploy it to the cloud.

Videos
- Deployment Prerequisites
- Google Cloud Permissions
- Deploying to Google Cloud

Resources
- [Installing Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Installing `gcloud` CLI](https://cloud.google.com/sdk/docs/install)
- [Mage Terraform Templates](https://github.com/mage-ai/mage-ai-terraform-templates)

Additional Mage Guides
- [Terraform](https://docs.mage.ai/production/deploying-to-cloud/using-terraform)
- [Deploying to GCP with Terraform](https://docs.mage.ai/production/deploying-to-cloud/gcp/setup)

### 2.2.8 - 🧱 Advanced Blocks (Optional)

Our final learning section is also optional— on using advanced block methods. We'll cover dynamic blocks, conditional blocks, replica blocks, and callback blocks. These are all advanced topics, but they're also very powerful and can help take your pipelines to the next level. 

Videos
- Advanced Blocks

Resources
- [Dynamic Blocks](https://docs.mage.ai/design/blocks/dynamic-blocks)
- [Conditional Blocks](https://docs.mage.ai/design/blocks/conditionals)
- [Replica Blocks](https://docs.mage.ai/guides/blocks/replicate-blocks#why-is-replicating-blocks-useful)
- [Callback Blocks](https://docs.mage.ai/design/blocks/callbacks)


### 2.2.9 - 🗒️ Homework 

We've prepared a brief homework assignment to help you practice what you've learned. Give it a go and feel free to reach out to us on Slack if you have any questions! You can also find the solutions in the [solutions](https://github.com/mattppal/data-engineering-zoomcamp/tree/matt/mage/week_2_workflow_orchestration#-solutions-and-examples) section.

Videos
- Homework Overview

Resources
- [Homework](../cohorts/2024/week_2_workflow_orchestration/homework.md).

### 2.2.10 - 👣 Next Steps

Congratulations! You've completed Week 2 of the Data Engineering Zoomcamp. We hope you've enjoyed learning about Mage and that you're excited to use it in your final project. If you have any questions, feel free to reach out to us on Slack. Be sure to check out our "Next Steps" video for some inspiration for the rest of your journey 😄.

Videos
- Next Steps

Resources
- [Slides](https://docs.google.com/presentation/d/1yN-e22VNwezmPfKrZkgXQVrX5owDb285I2HxHWgmAEQ/edit#slide=id.g262fb0d2905_0_12)

### 📑 Additional Resources

- [Mage Docs](https://docs.mage.ai/)
- [Mage Guides](https://docs.mage.ai/guides)
- [Mage Slack](https://www.mage.ai/chat)

### ✅ Solutions and Examples

If you're looking for the solutions _or_ completed examples from the course, you can take a look at the `solutions` [branch](https://github.com/mage-ai/mage-zoomcamp/blob/solutions) of the course repo.

```bash
git checkout solutions
```

Running `docker compose up` on the solutions branch will start the container with the solutions loaded. _Note: this will overwrite the files in your local repo. Be sure to commit your files to a separate branch if you'd like to save your work._

Navigate to http://localhost:6789 in your browser to see the solutions. Optionally, use [tag sorting](http://localhost:6789/pipelines?group_by=tag) to group solutions by tag.

# Community notes

Did you take notes? You can share them here:

## 2024 notes

*

## 2023 notes

* [Blog by Marcos Torregrosa (Prefect)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-2/)
* [Notes from Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week2)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week2.md)
* [Notes by Candace Williams](https://github.com/teacherc/de_zoomcamp_candace2023/blob/main/week_2/week2_notes.md)
* [Notes from Xia He-Bleinagel](https://xiahe-bleinagel.com/2023/02/week-2-data-engineering-zoomcamp-notes-prefect/)
* [Notes from froukje](https://github.com/froukje/de-zoomcamp/blob/main/week_2_workflow_orchestration/notes/notes_week_02.md)
* [Notes from Balaji](https://github.com/Balajirvp/DE-Zoomcamp/blob/main/Week%202/Detailed%20Week%202%20Notes.ipynb)


## 2022 notes 

Most of these notes are about Airflow, but you might find them useful.

* [Notes from Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/2_data_ingestion.md)
* [Notes from Aaron Wright](https://github.com/ABZ-Aaron/DataEngineerZoomCamp/blob/master/week_2_data_ingestion/README.md)
* [Notes from Abd](https://itnadigital.notion.site/Week-2-Data-Ingestion-ec2d0d36c0664bc4b8be6a554b2765fd)
* [Blog post by Isaac Kargar](https://kargarisaac.github.io/blog/data%20engineering/jupyter/2022/01/25/data-engineering-w2.html)
* [Blog, notes, walkthroughs by Sandy Behrens](https://learningdataengineering540969211.wordpress.com/2022/01/30/week-2-de-zoomcamp-2-3-2-ingesting-data-to-gcp-with-airflow/)
* [Notes from Vincenzo Galante](https://binchentso.notion.site/Data-Talks-Club-Data-Engineering-Zoomcamp-8699af8e7ff94ec49e6f9bdec8eb69fd)
* More on [Pandas vs SQL, Prefect capabilities, and testing your data](https://medium.com/@verazabeida/zoomcamp-2023-week-3-7f27bb8c483f), by Vera
