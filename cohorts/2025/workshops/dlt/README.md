# Data ingestion with dlt

Homework: [dlt_homework.md](dlt_homework.md)

🎥 **Watch the workshop video**

[![Watch the workshop video](https://markdown-videos-api.jorgenkh.no/youtube/pgJWP_xqO1g)](https://www.youtube.com/watch?v=pgJWP_xqO1g "Watch the workshop video")

Welcome to this hands-on workshop, where you'll learn to build efficient and scalable data ingestion pipelines.

### **What will you learn in this workshop?**  

In this workshop, you’ll learn the core skills required to build and manage data pipelines:  
- **How to build robust, scalable, and self-maintaining pipelines**.  
- **Best practices**, like built-in data governance, for ensuring clean and reliable data flows.  
- **Incremental loading techniques** to refresh data quickly and cost-effectively.  
- **How to build a Data Lake** with dlt.

By the end of this workshop, you'll be able to build data pipelines like a senior data engineer — quickly, concisely, and with best practices baked in.


--- 

## 📂 Navigation & Resources

- Workshop:
  - [Workshop content](data_ingestion_workshop.md).
  - [Workshop Colab Notebook](https://colab.research.google.com/drive/1FiAHNFenM8RyptyTPtDTfqPCi5W6KX_V?usp=sharing).
- Homework:
  - [Homework Markdown](dlt_homework.md).
  - [Homework Colab Notebook](https://colab.research.google.com/drive/1plqdl33K_HkVx0E0nGJrrkEUssStQsW7).
- 🌐 [Official dlt Documentation](https://dlthub.com/docs/intro).
- 💬 Join our [Slack Community](https://dlthub.com/community).

---

## 📖 Course overview
This workshop is structured into three key parts:

1️⃣ **[Extracting Data](data_ingestion_workshop.md#extracting-data)** – Learn scalable data extraction techniques.  
2️⃣ **[Normalizing Data](data_ingestion_workshop.md#normalizing-data)** – Clean and structure data before loading.  
3️⃣ **[Loading & Incremental Updates](data_ingestion_workshop.md#loading-data)** – Efficiently load and update data.  

📌 **Find the full course file here**: [Course File](data_ingestion_workshop.md)  

---

## 👩‍🏫 Teacher

Welcome to the DataTalks.Club Data Engineering Zoomcamp the data ingestion workshop!

I'm Violetta Mishechkina, Solutions Engineer at dltHub. 👋
- I’ve been working in the data field since 2018, with a background in machine learning.
- I started as a Data Scientist, training ML models and neural networks.
- Over time, I realized that in production, hitting the highest RMSE isn’t as important as model size, infrastructure, and data quality - so I transitioned into MLOps.
- A year ago, I joined dltHub’s Customer Success team and discovered dlt, a Python library that automates 90% of tedious data engineering tasks.
- Now, I work closely with customers and partners to help them integrate and optimize dlt in production.
- I also collaborate with our development team as the voice of the customer, ensuring our product meets real-world data engineering needs.
- My experience across ML, MLOps, and data engineering gives me a practical, hands-on perspective on solving data challenges.

---

## Homework

- [Homework Markdown](dlt_homework.md).
- [Homework Colab Notebook](https://colab.research.google.com/drive/1plqdl33K_HkVx0E0nGJrrkEUssStQsW7).

--- 
## Next steps

As you are learning the various concepts of data engineering, 
consider creating a portfolio project that will further your own knowledge.

By demonstrating the ability to deliver end to end, you will have an easier time finding your first role. 
This will help regardless of whether your hiring manager reviews your project, largely because you will have a better 
understanding and will be able to talk the talk.

Here are some example projects that others did with dlt:
- Serverless dlt-dbt on cloud functions: [Article](https://docs.getdbt.com/blog/serverless-dlt-dbt-stack)
- Bird finder: [Part 1](https://publish.obsidian.md/lough-on-data/blogs/bird-finder-via-dlt-i), [Part 2](https://publish.obsidian.md/lough-on-data/blogs/bird-finder-via-dlt-ii)
- Event ingestion on GCP: [Article and repo](https://dlthub.com/docs/blog/streaming-pubsub-json-gcp)
- Event ingestion on AWS: [Article and repo](https://dlthub.com/docs/blog/dlt-aws-taktile-blog)
- Or see one of the many demos created by our working students: [Hacker news](https://dlthub.com/docs/blog/hacker-news-gpt-4-dashboard-demo), 
[GA4 events](https://dlthub.com/docs/blog/ga4-internal-dashboard-demo), 
[an E-Commerce](https://dlthub.com/docs/blog/postgresql-bigquery-metabase-demo), 
[Google Sheets](https://dlthub.com/docs/blog/google-sheets-to-data-warehouse-pipeline), 
[Motherduck](https://dlthub.com/docs/blog/dlt-motherduck-demo), 
[MongoDB + Holistics](https://dlthub.com/docs/blog/MongoDB-dlt-Holistics), 
[Deepnote](https://dlthub.com/docs/blog/deepnote-women-wellness-violence-tends), 
[Prefect](https://dlthub.com/docs/blog/dlt-prefect),
[PowerBI vs GoodData vs Metabase](https://dlthub.com/docs/blog/semantic-modeling-tools-comparison),
[Dagster](https://dlthub.com/docs/blog/dlt-dagster),
[Ingesting events via gcp webhooks](https://dlthub.com/docs/blog/dlt-webhooks-on-cloud-functions-for-event-capture),
[SAP to snowflake replication](https://dlthub.com/docs/blog/sap-hana-to-snowflake-demo-blog),
[Read emails and send sumamry to slack with AI and Kestra](https://dlthub.com/docs/blog/dlt-kestra-demo-blog),
[Mode +dlt capabilities](https://dlthub.com/docs/blog/dlt-mode-blog),
[dbt on cloud functions](https://dlthub.com/docs/blog/dlt-dbt-runner-on-cloud-functions)
- If you want to use dlt in your project, [check this list of public APIs](https://dlthub.com/docs/blog/practice-api-sources)


If you create a personal project, consider submitting it to our blog - we will be happy to showcase it. Just drop us a line in the dlt Slack.



## **💛 If you enjoy dlt, support us!**  

* ⭐ **Give us a [GitHub Star](https://github.com/dlt-hub/dlt)!**  
* 💬 **Join our [Slack Community](https://dlthub.com/community)!**  
* 🚀 **Let’s build great data pipelines together!**  

---

# Community notes

Did you take notes? You can share them by creating a PR to this file!

* [Ingest Data to GCS by dlt from peatwan](https://github.com/peatwan/de-zoomcamp/tree/main/workshop/dlt/homework/load_to_gcs)
* Add your notes above this line