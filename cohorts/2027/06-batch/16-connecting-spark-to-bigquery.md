---
video_url: https://www.youtube.com/watch?v=HIm2BOj8C0Q
---
# Connecting Spark to BigQuery

> [!WARNING]
> **Scaffold — the lesson text for this unit has not been written.**
> Everything on this page was carried over mechanically: the title, the video
> and the material that already existed in the repository. Nothing here
> explains the topic. Watch the video; do not read this page as the lesson.

<!-- SCAFFOLD-NO-WRITEUP -->

Upload the script to GCS:

```bash
gsutil -m cp -r 06_spark_sql_big_query.py gs://dtc_data_lake_de-zoomcamp-nytaxi/code/06_spark_sql_big_query.py
```

Write results to big query ([docs](https://cloud.google.com/dataproc/docs/tutorials/bigquery-connector-spark-example#pyspark)):

```bash
gcloud dataproc jobs submit pyspark \
    --cluster=de-zoomcamp-cluster \
    --region=europe-west6 \
    --jars=gs://spark-lib/bigquery/spark-bigquery-latest_2.12.jar \
    gs://dtc_data_lake_de-zoomcamp-nytaxi/code/06_spark_sql_big_query.py \
    -- \
        --input_green=gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/green/2020/*/ \
        --input_yellow=gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/yellow/2020/*/ \
        --output=trips_data_all.reports-2020
```

There can be issue with latest Spark version and the Big query connector. Download links to the jar file for respective Spark versions can be found at:
[Spark and Big query connector](https://github.com/GoogleCloudDataproc/spark-bigquery-connector)

**Note**: Dataproc on GCE 2.1+ images pre-install Spark BigQquery connector: [DataProc Release 2.2](https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-release-2.2). Therefore, no need to include the jar file in the job submission.

The script is [`code/06_spark_sql_big_query.py`](code/06_spark_sql_big_query.py).
