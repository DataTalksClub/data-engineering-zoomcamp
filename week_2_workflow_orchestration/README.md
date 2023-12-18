## Week 2: Workflow Orchestration

> If you're looking for Airflow videos from the 2022 edition,
> check the [2022 cohort folder](../cohorts/2022/week_2_data_ingestion/).
> If you're looking for Prefect videos from the 2023 edition,
> check the [2023 cohort folder](../cohorts/2023/week_2_data_ingestion/).

Python code from videos is linked [below](#code-repository).

### Data Lake (GCS)

* What is a Data Lake
* ELT vs. ETL
* Alternatives to components (S3/HDFS, Redshift, Snowflake etc.)
* [Video](https://www.youtube.com/watch?v=W3Zm6rjOq70&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* [Slides](https://docs.google.com/presentation/d/1RkH-YhBz2apIjYZAxUz2Uks4Pt51-fVWVN9CcH9ckyY/edit?usp=sharing)

### Course Resources

#### 2.2.1 - Intro to Orchestration

Videos
- What is Orchestration?

Resources
- [Slides](https://docs.google.com/presentation/d/17zSxG5Z-tidmgY-9l7Al1cPmz4Slh4VPK6o2sryFYvw/)

#### 2.2.2 - Intro to Mage

Videos
- What is Mage?
- Configuring Mage
- A Simple Pipeline

Resources
- [Getting Started Repo](https://github.com/mage-ai/mage-zoomcamp)
- [Slides](https://docs.google.com/presentation/d/1y_5p3sxr6Xh1RqE6N8o2280gUzAdiic2hPhYUUD6l88/)

#### 2.2.3 - ETL: API to Postgres

Videos
- Configuring Postgres
- Writing an ETL Pipeline

Resources
- [Taxi Dataset](https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz)
- [Sample loading block](https://github.com/mage-ai/mage-zoomcamp/blob/solutions/magic-zoomcamp/data_loaders/load_nyc_taxi_data.py)

#### 2.2.4 - ETL: API to GCS

Videos
- Configuring GCP
- Writing an ETL Pipeline

Resources
- [DTC Zoomcamp GCP Setup](../week_1_basics_n_setup/1_terraform_gcp/2_gcp_overview.md)

#### 2.2.5 - ETL: GCS to BigQuery
- Writing an ETL Pipeline

#### 2.2.6 - Advanced Functionality

Videos
- Advanced Functionality

Resources
- [Dynamic Blocks](https://docs.mage.ai/design/blocks/dynamic-blocks)
- [Conditional Blocks](https://docs.mage.ai/design/blocks/conditionals)
- [Replica Blocks](https://docs.mage.ai/guides/blocks/replicate-blocks#why-is-replicating-blocks-useful)
- [Callback Blocks](https://docs.mage.ai/design/blocks/callbacks)
- [Pipeline Variables](https://docs.mage.ai/development/variables/overview)

#### Homework 

Homework can be found [here](../cohorts/2024/week_2_workflow_orchestration/homework.md).

If you're looking for the solutions _or_ completed examples from the course, you can take a look at the `solutions` [branch](https://github.com/mage-ai/mage-zoomcamp/blob/solutions) of the course repo.

```bash
git checkout solutions
```

Running `docker compose up` on the solutions branch will start the container with the solutions loaded. _Note: this will overwrite the files in your local repo. Be sure to commit your files to a separate branch if you'd like to save your work._

Navigate to http://localhost:6789 in your browser to see the solutions. Optionally, use [tag sorting](http://localhost:6789/pipelines?group_by=tag) to group solutions by tag.

## Community notes

Did you take notes? You can share them here:

### 2024 notes

*

### 2023 notes

* [Blog by Marcos Torregrosa (Prefect)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-2/)
* [Notes from Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week2)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week2.md)
* [Notes by Candace Williams](https://github.com/teacherc/de_zoomcamp_candace2023/blob/main/week_2/week2_notes.md)
* [Notes from Xia He-Bleinagel](https://xiahe-bleinagel.com/2023/02/week-2-data-engineering-zoomcamp-notes-prefect/)
* [Notes from froukje](https://github.com/froukje/de-zoomcamp/blob/main/week_2_workflow_orchestration/notes/notes_week_02.md)
* [Notes from Balaji](https://github.com/Balajirvp/DE-Zoomcamp/blob/main/Week%202/Detailed%20Week%202%20Notes.ipynb)


### 2022 notes 

Most of these notes are about Airflow, but you might find them useful.

* [Notes from Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/2_data_ingestion.md)
* [Notes from Aaron Wright](https://github.com/ABZ-Aaron/DataEngineerZoomCamp/blob/master/week_2_data_ingestion/README.md)
* [Notes from Abd](https://itnadigital.notion.site/Week-2-Data-Ingestion-ec2d0d36c0664bc4b8be6a554b2765fd)
* [Blog post by Isaac Kargar](https://kargarisaac.github.io/blog/data%20engineering/jupyter/2022/01/25/data-engineering-w2.html)
* [Blog, notes, walkthroughs by Sandy Behrens](https://learningdataengineering540969211.wordpress.com/2022/01/30/week-2-de-zoomcamp-2-3-2-ingesting-data-to-gcp-with-airflow/)
* [Notes from Vincenzo Galante](https://binchentso.notion.site/Data-Talks-Club-Data-Engineering-Zoomcamp-8699af8e7ff94ec49e6f9bdec8eb69fd)
* More on [Pandas vs SQL, Prefect capabilities, and testing your data](https://medium.com/@verazabeida/zoomcamp-2023-week-3-7f27bb8c483f), by Vera
