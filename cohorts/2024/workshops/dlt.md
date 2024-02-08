# Data ingestion with dlt

​In this hands-on workshop, we’ll learn how to build data ingestion pipelines.

​We’ll cover the following steps:

* ​Extracting data from APIs, or files.
* ​Normalizing and loading data
* ​Incremental loading

​By the end of this workshop, you’ll be able to write data pipelines like a senior data engineer: Quickly, concisely, scalable, and self-maintaining.



--- 

# Navigation

* [Workshop content](dlt_resources/data_ingestion_workshop.md)
* [Workshop notebook](dlt_resources/workshop.ipynb)
* [Homework starter notebook](dlt_resources/homework_starter.ipynb)

# Resources

- Website and community: Visit our [docs](https://dlthub.com/docs/intro), discuss on our slack (Link at top of docs).
- Course colab: [Notebook](https://colab.research.google.com/drive/1kLyD3AL-tYf_HqCXYnA3ZLwHGpzbLmoj#scrollTo=5aPjk0O3S_Ag&forceEdit=true&sandboxMode=true).
- dlthub [community Slack](https://dlthub.com/community).

---

# Teacher

Welcome to the data talks club data engineering zoomcamp, the data ingestion workshop.

- My name is [Adrian](https://www.linkedin.com/in/data-team/), and I work in the data field since 2012
    - I built many data warehouses some lakes, and a few data teams
    - 10 years into my career I started working on dlt “data load tool”, which is an open source library to enable data engineers to build faster and better.
    - I started working on dlt because data engineering is one of the few areas of software engineering where we do not have developer tools to do our work.
    - Building better pipelines would require more code re-use - we cannot all just build perfect pipelines from scratch every time.
    - And so dlt was born, a library that automates the tedious part of data ingestion: Loading, schema management, data type detection, scalability, self healing, scalable extraction… you get the idea - essentially a data engineer’s “one stop shop” for best practice data pipelining.
    - Due to its **simplicity** of use, dlt enables **laymen** to
        - Build pipelines 5-10x faster than without it
        - Build self healing, self maintaining pipelines with all the best practices of data engineers. Automating schema changes removes the bulk of maintenance efforts.
        - Govern your pipelines with schema evolution alerts and data contracts.
        - and generally develop pipelines like a senior, commercial data engineer.

--- 

# Course
You can find the course file [here](./dlt_resources/data_ingestion_workshop.md)
The course has 3 parts
- [Extraction Section](./dlt_resources/data_ingestion_workshop.md#extracting-data): In this section we will learn about scalable extraction
- [Normalisation Section](./dlt_resources/data_ingestion_workshop.md#normalisation): In this section we will learn to prepare data for loading
- [Loading Section](./dlt_resources/data_ingestion_workshop.md#incremental-loading)): Here we will learn about incremental loading modes

---

# Homework

The [linked colab notebook](https://colab.research.google.com/drive/1Te-AT0lfh0GpChg1Rbd0ByEKOHYtWXfm#scrollTo=wLF4iXf-NR7t&forceEdit=true&sandboxMode=true) offers a few exercises to practice what you learned today.


#### Question 1: What is the sum of the outputs of the generator for limit = 5?
- **A**: 10.23433234744176
- **B**: 7.892332347441762
- **C**: 8.382332347441762
- **D**: 9.123332347441762

#### Question 2: What is the 13th number yielded by the generator?
- **A**: 4.236551275463989
- **B**: 3.605551275463989
- **C**: 2.345551275463989
- **D**: 5.678551275463989

#### Question 3: Append the 2 generators. After correctly appending the data, calculate the sum of all ages of people.
- **A**: 353
- **B**: 365
- **C**: 378
- **D**: 390

#### Question 4: Merge the 2 generators using the ID column. Calculate the sum of ages of all the people loaded as described above.
- **A**: 215
- **B**: 266
- **C**: 241
- **D**: 258

Submit the solution here: https://courses.datatalks.club/de-zoomcamp-2024/homework/workshop1

--- 
# Next steps

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
[google sheets](https://dlthub.com/docs/blog/google-sheets-to-data-warehouse-pipeline), 
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


If you create a personal project, consider submitting it to our blog - we will be happy to showcase it. Just drop us a line in the dlt slack.



**And don't forget, if you like dlt**
- **Give us a [GitHub Star!](https://github.com/dlt-hub/dlt)**
- **Join our [Slack community](https://dlthub.com/community)**


# Notes

* Add your notes here
