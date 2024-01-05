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

Here's a rough course syllabus:

2.2.1 - 📯 Intro to Orchestration
* An overview of orchestration as a concept, and how it fits into the data engineering landscape.

2.2.2 - 🧙‍♂️ Intro to Mage
* An overview of Mage as a platform, and how it fits into the data engineering landscape.

2.2.3 - 🐘 ETL: API to Postgres
* Writing an ETL pipeline to load data from an API into a Postgres database.

2.2.4 - 🤓 ETL: API to GCS
* Writing an ETL pipeline to load data from an API into GCS.

2.2.5 - 🔍 ETL: GCS to BigQuery
* Writing an ETL pipeline to load data from GCS into BigQuery.

2.2.6 - 👨‍💻 Parameterized Execution
* Writing a parameterized pipeline to load data from an API into GCS.

2.2.7 - 🤖 Deployment (Optional)
* Deploying a pipeline to Google Cloud.

2.2.8 - 🧱 Advanced Blocks (Optional)
* An overview of advanced blocks, including dynamic blocks, conditional blocks, replica blocks, and callback blocks.

2.2.9 - 🗒️ Homework 
* Homework overview and instructions

2.2.10 - 👣 Next Steps
* wrap up

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

Videos
- What is Orchestration?

Resources
- [Slides](https://docs.google.com/presentation/d/17zSxG5Z-tidmgY-9l7Al1cPmz4Slh4VPK6o2sryFYvw/)

### 2.2.2 - 🧙‍♂️ Intro to Mage

Videos
- What is Mage?
- Configuring Mage
- A Simple Pipeline

Resources
- [Getting Started Repo](https://github.com/mage-ai/mage-zoomcamp)
- [Slides](https://docs.google.com/presentation/d/1y_5p3sxr6Xh1RqE6N8o2280gUzAdiic2hPhYUUD6l88/)

### 2.2.3 - 🐘 ETL: API to Postgres

Videos
- Configuring Postgres
- Writing an ETL Pipeline

Resources
- [Taxi Dataset](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz)
- [Sample loading block](https://github.com/mage-ai/mage-zoomcamp/blob/solutions/magic-zoomcamp/data_loaders/load_nyc_taxi_data.py)

### 2.2.4 - 🤓 ETL: API to GCS

Videos
- Configuring GCP
- Writing an ETL Pipeline

Resources
- [DTC Zoomcamp GCP Setup](../week_1_basics_n_setup/1_terraform_gcp/2_gcp_overview.md)

### 2.2.5 - 🔍 ETL: GCS to BigQuery

Videos
- Writing an ETL Pipeline

### 2.2.6 - 👨‍💻 Parameterized Execution
Videos
- Parameterized Execution

Resources
- [Mage Variables Overview](https://docs.mage.ai/development/variables/overview)
- [Mage Runtime Variables](https://docs.mage.ai/getting-started/runtime-variable)

### 2.2.7 - 🤖 Deployment (Optional)
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
Videos
- Advanced Blocks

Resources
- [Dynamic Blocks](https://docs.mage.ai/design/blocks/dynamic-blocks)
- [Conditional Blocks](https://docs.mage.ai/design/blocks/conditionals)
- [Replica Blocks](https://docs.mage.ai/guides/blocks/replicate-blocks#why-is-replicating-blocks-useful)
- [Callback Blocks](https://docs.mage.ai/design/blocks/callbacks)


### 2.2.9 - 🗒️ Homework 

Videos
- Homework Overview

Resources
- [Homework](../cohorts/2024/week_2_workflow_orchestration/homework.md).

### 2.2.10 - 👣 Next Steps

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
