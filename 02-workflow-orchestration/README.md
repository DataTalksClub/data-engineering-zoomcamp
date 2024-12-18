# Week 2: Workflow Orchestration

Welcome to Week 2 of the Data Engineering Zoomcamp! This week, we'll cover workflow orchestration with [Kestra](https://go.kestra.io/de-zoomcamp/github).

Kestra is an open-source, event-driven orchestration platform that makes both scheduled and event-driven workflows easy. By bringing Infrastructure as Code best practices to data, process, and microservice orchestration, you can build reliable workflows [directly from the UI](https://go.kestra.io/de-zoomcamp/quickstart) in just a few lines of YAML.

The course will cover the basics of workflow orchestration, why it's important, and how it can be used to build data engineering pipelines. 

## Introduction to Workflow Orchestration

In this section, we'll cover the basics of workflow orchestration. We'll discuss what it is, why it's important, and how it can be used to build data pipelines.

Videos
- Introduction to Workflow Orchestration

[![](https://markdown-videos-api.jorgenkh.no/youtube/ZV6CPZDiJFA)](https://youtu.be/ZV6CPZDiJFA?si=nd3mW_VydPByu4D4)

## Introduction to Kestra

In this section, you'll learn what is Kestra, how to use it, and how to build a Hello-World data pipeline.

Videos
- Introduction to Kestra

[![](https://markdown-videos-api.jorgenkh.no/youtube/a2BZ7vOihjg)](https://youtu.be/a2BZ7vOihjg?si=XoJY8vt61LPumTed)

- Launch Kestra using Docker Compose

[![](https://markdown-videos-api.jorgenkh.no/youtube/SGL8ywf3OJQ)](https://youtu.be/SGL8ywf3OJQ?si=aY2_NFpYLaOlKEaZ)

- Kestra Fundamentals

[![](https://markdown-videos-api.jorgenkh.no/youtube/HR47SY2RkPQ)](https://youtu.be/HR47SY2RkPQ?si=S7ic1ASWhmi_O0oN)

Resources
- [Quickstart Guide](https://kestra.io/docs/getting-started/quickstart)
- [Tutorial](https://kestra.io/docs/getting-started/tutorial)

## ETL: Extract data and load it to Postgres

In this section, we'll cover how you can ingest the Yellow Taxi data from the NYC Taxi and Limousine Commission (TLC) and load it into a Postgres database. We'll cover how to extract data from [CSV files](https://github.com/DataTalksClub/nyc-tlc-data/releases), and load them into a local Postgres database running in a Docker container.

> [!NOTE]  
> The TLC Trip Record Data provided on the [nyc.gov](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page) website is currently available only in a Parquet format, but this is NOT the dataset we're going to use in this course. For the purpose of this course, we'll use the **CSV files** available [here on GitHub](https://github.com/DataTalksClub/nyc-tlc-data/releases). This is because the Parquet format can be challenging to understand by newcomers, and we want to make the course as accessible as possible — the CSV format can be easily introspected using tools like Excel or Google Sheets, or even a simple text editor.
## ETL: Extract data and load it to Google Cloud

So far, you've explored how to run ETL locally using Postgres, we'll do the same on GCP. We'll load the same data to:
1. Data lake using Google Cloud Storage (GCS) 
2. Data Warehouse using BigQuery.

## Scheduling and Backfills

In this section, we'll cover how you can schedule your data pipelines to run at specific times. We'll also cover how you can backfill your data pipelines to run on historical data.

We'll demonstrate backfills first locally using Postgres and then on GCP using GCS and BigQuery.

## Homework 

The homework for this week can be found [here](./02-workflow-orchestration/homework.md). Don't worry, it's just a bunch of Multiple Choice Questions to test your understanding of Kestra, Workflow Orchestration, and ETL pipelines for a data lake and data warehouse.

## Additional Resources

- Check [Kestra Docs](https://go.kestra.io/de-zoomcamp/docs)
- Explore our [Blueprints](https://go.kestra.io/de-zoomcamp/blueprints) library
- Browse over 600 [plugins](https://go.kestra.io/de-zoomcamp/plugins) available in Kestra
- Give us a star on [GitHub](https://go.kestra.io/de-zoomcamp/github)
- Join our [Slack community](https://go.kestra.io/de-zoomcamp/slack) if you have any questions
- Find all the videos in this [YouTube Playlist](https://go.kestra.io/de-zoomcamp/yt-playlist)

## Troubleshooting tips

If you encounter similar errors to:

```
BigQueryError{reason=invalid, location=null, 
message=Error while reading table: kestra-sandbox.zooomcamp.yellow_tripdata_2020_01, 
error message: CSV table references column position 17, but line contains only 14 columns.; 
line_number: 2103925 byte_offset_to_start_of_line: 194863028 
column_index: 17 column_name: "congestion_surcharge" column_type: NUMERIC 
File: gs://anna-geller/yellow_tripdata_2020-01.csv}
```

It means that the CSV file you're trying to load into BigQuery has a mismatch in the number of columns between the external source table (i.e. file in GCS) and the destination table in BigQuery. This can happen when for due to network/transfer issues, the file is not fully downloaded from GitHub or not correctly uploaded to GCS. The error suggests schema issues but that's not the case. Simply rerun the entire execution including redownloading the CSV file and reuploading it to GCS. This should resolve the issue.


# Community notes

Did you take notes? You can share them here. Just create a PR to this file and add your notes below.

* Add your notes here (above this line)


## Previous editions

* [Airflow videos from 2022](../cohorts/2022/week_2_data_ingestion/) and [commmunity notes](../cohorts/2024/02-workflow-orchestration/#community-notes)
* [Prefect videos from 2023](../cohorts/2023/week_2_data_ingestion/) and [community notes](../cohorts/2023/week_2_workflow_orchestration#community-notes)
* [Mage videos from 2024](../cohorts/2024/02-workflow-orchestration/) and [community notes](../cohorts/2022/week_2_data_ingestion#community-notes)
