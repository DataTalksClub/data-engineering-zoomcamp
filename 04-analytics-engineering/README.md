# Module 4: Analytics Engineering

Goal: Transforming the data loaded in DWH into Analytical Views developing a [dbt project](taxi_rides_ny/README.md).

### Prerequisites

The prerequisites depend on which setup path you choose:

**For Cloud Setup (BigQuery):**

- Completed [Module 3: Data Warehouse](../03-data-warehouse/) with:
  - A GCP project with BigQuery enabled
  - Service account with BigQuery permissions
  - NYC taxi data loaded into BigQuery (yellow and green taxi data for 2019-2020)

**For Local Setup (DuckDB):**

- No prerequisites! The local setup guide will walk you through downloading and loading the data.

> [!NOTE]
> This module focuses on **yellow and green taxi data** (2019-2020). While Module 3 may have included FHV data, it is not used in this dbt project.

## Setting up your environment

Choose your setup path:

### 🏠 [Local Setup](setup/local_setup.md)

- **Stack**: DuckDB + dbt Core + Streamlit
- **Cost**: Free
- [→ Get Started](setup/local_setup.md)

### ☁️ [Cloud Setup](setup/cloud_setup.md)

- **Stack**: BigQuery + dbt Cloud + Looker Studio
- **Cost**: Free tier available (dbt Cloud Developer), BigQuery costs vary
- **Requires**: Completed Module 3 with BigQuery data
- [→ Get Started](setup/cloud_setup.md)

## Content

### Introduction to Analytics Engineering

:movie_camera: What is Analytics Engineering?

### Introduction to data modeling

[![](https://markdown-videos-api.jorgenkh.no/youtube/uF76d5EmdtU)](https://youtu.be/uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=40)

### What is dbt?

[![](https://markdown-videos-api.jorgenkh.no/youtube/4eCouvVOJUw)](https://www.youtube.com/watch?v=gsKuETFJr54&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=5)

### Project Setup

| Alternative A  | Alternative B   |
|-----------------------------|--------------------------------|
| BigQuery + dbt Platform | DuckDB + dbt core |
| [![](https://markdown-videos-api.jorgenkh.no/url?url=https%3A%2F%2Fyoutu.be%2FGFbwlrt6f54)](https://youtu.be/GFbwlrt6f54) | [![](https://markdown-videos-api.jorgenkh.no/url?url=https%3A%2F%2Fyoutu.be%2FqkuTGB40PBc)](https://youtu.be/qkuTGB40PBc)|

### dbt models

:movie_camera: dbt models

### Testing and Documentation

:movie_camera: Testing and documenting

### Other features

:movie_camera: Other features

### Deployment

| Alternative A  | Alternative B   |
|-----------------------------|--------------------------------|
| Using BigQuery + dbt cloud | Using DuckDB + dbt core (locally) |
| :movie_camera: Deployment A | :movie_camera: Deployment B |

### Visualizing the transformed data

| Alternative A  | Alternative B   |
|-----------------------------|--------------------------------|
| Using BigQuery + dbt cloud | Using DuckDB + dbt core (locally) |
| :movie_camera: Google Looker studio | :movie_camera: Streamlit Video |

## Extra resources

> [!NOTE]
> If you find the videos above overwhelming, we recommend completing the [dbt Fundamentals](https://learn.getdbt.com/courses/dbt-fundamentals) course and then rewatching the module. It provides a solid foundation for all the key concepts you need in this module.

## SQL refresher

The homework for this module focuses heavily on window functions and CTEs. If you need a refresher on these topics, you can refer to these notes.

* [SQL refresher](refreshers/SQL.md)

## Homework

* [2026 Homework](../cohorts/2026/04-analytics-engineering/homework.md)

# Community notes

<details>
<summary>Did you take notes? You can share them here</summary>

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/4_analytics.md)
* [Sandy's DE learning blog](https://learningdataengineering540969211.wordpress.com/2022/02/17/week-4-setting-up-dbt-cloud-with-bigquery/)
* [Notes by Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week4)
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-4/)
* [Notes by froukje](https://github.com/froukje/de-zoomcamp/blob/main/week_4_analytics_engineering/notes/notes_week_04.md)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week4.md)
* [Setting up Prefect with dbt by Vera](https://medium.com/@verazabeida/zoomcamp-week-5-5b6a9d53a3a0)
* [Blog by Xia He-Bleinagel](https://xiahe-bleinagel.com/2023/02/week-4-data-engineering-zoomcamp-notes-analytics-engineering-and-dbt/)
* [Setting up DBT with BigQuery by Tofag](https://medium.com/@fagbuyit/setting-up-your-dbt-cloud-dej-9-d18e5b7c96ba)
* [Blog post by Dewi Oktaviani](https://medium.com/@oktavianidewi/de-zoomcamp-2023-learning-week-4-analytics-engineering-with-dbt-53f781803d3e)
* [Notes from Vincenzo Galante](https://binchentso.notion.site/Data-Talks-Club-Data-Engineering-Zoomcamp-8699af8e7ff94ec49e6f9bdec8eb69fd)
* [Notes from Balaji](https://github.com/Balajirvp/DE-Zoomcamp/blob/main/Week%204/Data%20Engineering%20Zoomcamp%20Week%204.ipynb)
* [Notes by Linda](https://github.com/inner-outer-space/de-zoomcamp-2024/blob/main/4-analytics-engineering/readme.md)
* [2024 - Videos transcript week4](https://drive.google.com/drive/folders/1V2sHWOotPEMQTdMT4IMki1fbMPTn3jOP?usp=drive)
* [Blog Post](https://www.jonahboliver.com/blog/de-zc-w4) by Jonah Oliver
* [2025 Notes by Manuel Guerra](https://github.com/ManuelGuerra1987/data-engineering-zoomcamp-notes/blob/main/4_Analytics-Engineering/README.md)
* [2025 Notes by Horeb SEIDOU](https://spotted-hardhat-eea.notion.site/Week-4-Analytics-Engineering-18929780dc4a808692e4e0ee488bf49c?pvs=74)
* [2025 Notes by Daniel Lachner](https://github.com/mossdet/dlp_data_eng/blob/main/Notes/04_01_Analytics_Engineering.pdf)
* Add your notes here (above this line)

</details>

## Useful links
- [Slides used in previous years](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true)
- [dbt free courses](https://courses.getdbt.com/collections)
