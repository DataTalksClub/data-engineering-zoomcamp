---
video_url: https://www.youtube.com/watch?v=CI3P4tAtru4
---
# Preparing Yellow and Green Taxi Data

> [!WARNING]
> **Scaffold — the lesson text for this unit has not been written.**
> Everything on this page was carried over mechanically: the title, the video
> and the material that already existed in the repository. Nothing here
> explains the topic. Watch the video; do not read this page as the lesson.

<!-- SCAFFOLD-NO-WRITEUP -->

This topic is marked optional in the module README.

## Materials

* [`code/download_data.sh`](code/download_data.sh) - downloads the yellow and
  green trip data for 2020 and 2021 into `data/raw/`.
* [`code/05_taxi_schema.ipynb`](code/05_taxi_schema.ipynb) - the explicit green
  and yellow schemas, and the loop that rewrites each month as partitioned
  parquet under `data/pq/`.

> [!NOTE]
> The other way to infer the schema (apart from pandas) for the csv files, is to set the `inferSchema` option to `true` while reading the files in Spark.
