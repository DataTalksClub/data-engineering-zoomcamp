# Workflow Orchestration

## Units

1. [What is Workflow Orchestration?](01-what-is-workflow-orchestration.md)
2. [What is Kestra?](02-what-is-kestra.md)
3. [Installing Kestra](03-installing-kestra.md)
4. [Kestra Concepts](04-kestra-concepts.md)
5. [Orchestrate Python Code](05-orchestrate-python-code.md)
6. [Getting Started Pipeline](06-getting-started-pipeline.md)
7. [Local DB: Load Taxi Data to Postgres](07-load-taxi-data-to-postgres.md)
8. [Local DB: Learn Scheduling and Backfills](08-scheduling-and-backfills.md)
9. [ETL vs ELT](09-etl-vs-elt.md)
10. [Setup Google Cloud Platform (GCP)](10-setup-google-cloud-platform.md)
11. [GCP Workflow: Load Taxi Data to BigQuery](11-load-taxi-data-to-bigquery.md)
12. [GCP Workflow: Schedule and Backfill Full Dataset](12-schedule-and-backfill-full-dataset.md)
13. [Introduction: Why AI for Workflows?](13-why-ai-for-workflows.md)
14. [Context Engineering with ChatGPT](14-context-engineering-with-chatgpt.md)
15. [AI Copilot in Kestra](15-ai-copilot-in-kestra.md)
16. [Bonus: Retrieval Augmented Generation (RAG)](16-retrieval-augmented-generation.md)
17. [Bonus: Deploy to the Cloud (Optional)](17-deploy-to-the-cloud.md)
18. [Additional Resources](18-additional-resources.md)

## Homework

* [Homework](homework.md)

## Sections

### 2.1 Introduction to Workflow Orchestration
In this section, you’ll learn the foundations of workflow orchestration, its importance, and how Kestra fits into the orchestration landscape.

### 2.2 Getting Started with Kestra
In this section, you'll learn how to install Kestra, as well as the key concepts required to build your first workflow. Once our first workflow is built, we can extend this further by executing a Python script inside of a workflow. 

You will:
1. Install Kestra using Docker Compose
2. Learn the concepts of Kestra to build your first workflow
3. Execute a Python script inside of a Kestra Flow

### 2.3 Hands-On Coding Project: Build Data Pipelines with Kestra
Next, we're gonna build ETL pipelines for Yellow and Green Taxi data from NYC’s Taxi and Limousine Commission (TLC). You will:
1. Extract data from [CSV files](https://github.com/DataTalksClub/nyc-tlc-data/releases).
2. Load it into Postgres or Google Cloud (GCS + BigQuery).
3. Explore scheduling and backfilling workflows.

### 2.4 ELT Pipelines in Kestra: Google Cloud Platform
Now that you've learned how to build ETL pipelines locally using Postgres, we are ready to move to the cloud. In this section, we'll load the same Yellow and Green Taxi data to Google Cloud Platform (GCP) using: 
1. Google Cloud Storage (GCS) as a data lake  
2. BigQuery as a data warehouse.

### 2.5 Using AI for Data Engineering in Kestra
This section builds on what you learned earlier in Module 2 to show you how AI can speed up workflow development.

By the end of this section, you will:
- Understand why context engineering matters when collaborating with LLMs
- Use AI Copilot to build Kestra flows faster
- Use Retrieval Augmented Generation (RAG) in data pipelines

#### Prerequisites
- Completion of earlier sections in Module 2 (Workflow Orchestration with Kestra)
- Kestra running locally
- Google Cloud account with access to Gemini API (there's a generous free tier!)

---

### 2.6 Bonus: Deploy to the Cloud (Optional)
Now that we've got all our pipelines working and we know how to quickly create new flows with Kestra's AI Copilot, we can deploy Kestra to the cloud so it can continue to orchestrate our scheduled pipelines. 

In this bonus section, we'll cover how you can deploy Kestra on Google Cloud and automatically sync your workflows from a Git repository.

Note: When committing your workflows to Kestra, make sure your workflow doesn't contain any sensitive information. You can use [Secrets](https://go.kestra.io/de-zoomcamp/secret) and the [KV Store](https://go.kestra.io/de-zoomcamp/kv-store) to keep sensitive data out of your workflow logic.

##### Resources
- [Install Kestra on Google Cloud](https://go.kestra.io/de-zoomcamp/gcp-install)
- [Moving from Development to Production](https://go.kestra.io/de-zoomcamp/dev-to-prod)
- [Using Git in Kestra](https://go.kestra.io/de-zoomcamp/git)
- [Deploy Flows with GitHub Actions](https://go.kestra.io/de-zoomcamp/deploy-github-actions)

### 2.7 Additional Resources
- Check [Kestra Docs](https://go.kestra.io/de-zoomcamp/docs)
- Explore our [Blueprints](https://go.kestra.io/de-zoomcamp/blueprints) library
- Browse over 600 [plugins](https://go.kestra.io/de-zoomcamp/plugins) available in Kestra
- Give us a star on [GitHub](https://go.kestra.io/de-zoomcamp/github)
- Join our [Slack community](https://go.kestra.io/de-zoomcamp/slack) if you have any questions
- Find all the videos in this [YouTube Playlist](https://go.kestra.io/de-zoomcamp/yt-playlist)


#### Troubleshooting tips
If you face any issues with Kestra flows in Module 2, make sure to use the following Docker images/ports:
- `image: kestra/kestra:v1.1` - pin your Kestra Docker image to this version so we can ensure reproducibility; do NOT use `kestra/kestra:develop` as this is a bleeding-edge development version that might contain bugs
- `postgres:18` — make sure to pin your Postgres image to version 18
- If you run `pgAdmin` or something else on port 8080, you can adjust Kestra `docker-compose` to use a different port, e.g. change port mapping to 18080 instead of 8080, and then access Kestra UI in your browser from http://localhost:18080/ instead of from http://localhost:8080/

If you are still facing any issues, stop and remove your existing Kestra + Postgres containers and start them again using `docker-compose up -d`. If this doesn't help, post your question on the DataTalksClub Slack or on Kestra's Slack http://kestra.io/slack.

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

---

## Companion files

* [`docker-compose.yml`](docker-compose.yml) — Kestra, Postgres and pgAdmin
* [`flows/`](flows/) — every Kestra flow used in this module

# Community notes

Did you take notes? You can share them by creating a PR to this file! 

* Add your notes above this line

---
