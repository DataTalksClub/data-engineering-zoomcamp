---
video_url: https://www.youtube.com/watch?v=HIm2BOj8C0Q
---
# Connecting Spark to BigQuery

In the previous units we created a Dataproc cluster, ran our Spark job on
it and wrote the report to Google Cloud Storage. This unit closes the
section: instead of writing to a bucket, we write the results straight
into BigQuery, our data warehouse. For the projects this is usually what
you want - the report lands in the warehouse, ready for dashboards.

## From parquet output to BigQuery output

Spark cannot write to BigQuery out of the box either - it needs a
connector. Google documents this in the
[BigQuery connector for Spark](https://cloud.google.com/dataproc/docs/tutorials/bigquery-connector-spark-example#pyspark)
tutorial, and we follow its example.

We start from the script of the previous units and make a copy,
`06_spark_sql_big_query.py` - the data reading and the aggregation SQL
stay the same, only the output changes. Instead of

```python
df_result.coalesce(1) \
    .write.parquet(output, mode='overwrite')
```

we write

```python
df_result.write.format('bigquery') \
    .option('table', output) \
    .save()
```

The output is no longer a folder but a BigQuery table, passed as
`schema.table` from the command line, and we do not need `coalesce(1)`
to merge the output files - BigQuery takes care of that.

The connector needs a temporary bucket: Spark first writes the results to
Google Cloud Storage and then loads them into BigQuery. We configure it
in the script:

```python
spark.conf.set('temporaryGcsBucket', 'dataproc-temp-europe-west6-828225226997-fckhkym8')
```

When you create a Dataproc cluster, it also creates a temporary bucket
like this one - we reuse it.

Upload the script to GCS:

```bash
gsutil -m cp -r 06_spark_sql_big_query.py gs://dtc_data_lake_de-zoomcamp-nytaxi/code/06_spark_sql_big_query.py
```

## The first attempt

Back in the Dataproc UI we submit the job the same way as before: PySpark,
the new script, and the arguments - the two parquet inputs and the output,
now a BigQuery table. Our project is `trips_data_all`, so the output is
`trips_data_all.reports-2020`:

* `--input_green=gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/green/2020/*/`
* `--input_yellow=gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/yellow/2020/*/`
* `--output=trips_data_all.reports-2020`

The job fails quickly with `Failed to find data source: bigquery`. Of
course - we never gave Spark the connector. Unlike Google Cloud Storage,
the BigQuery connector does not ship with every cluster, and Dataproc
cannot guess that we want it.

## Adding the connector jar

The fix is the same trick we used for the GCS connector on our local
Spark: give the job a jar. Google hosts the BigQuery connector on a
public bucket, so we can point the submission straight at it with
`--jars`:

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

There can be issues between the latest Spark version and the BigQuery
connector. Download links to the jar file for the respective Spark
versions can be found in the
[Spark BigQuery connector](https://github.com/GoogleCloudDataproc/spark-bigquery-connector)
repository. Note that Dataproc images on GCE 2.1 and newer come with the
connector pre-installed
([Dataproc Release 2.2](https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-release-2.2)),
so on a recent cluster you do not need the `--jars` flag at all.

## The table appears in BigQuery

This time the job runs through. An open question from before the run: what
happens when the output table does not exist? It turns out Spark simply
creates it. Open BigQuery, refresh, and there is `reports-2020` in the
`trips_data_all` dataset - with a preview of the monthly revenue rows our
job computed on the cluster.

The table has the expected grouping fields and revenue measures. The first
fields in its schema are:

| Field | Type | Mode |
| --- | --- | --- |
| `revenue_zone` | INTEGER | NULLABLE |
| `revenue_month` | TIMESTAMP | NULLABLE |
| `service_type` | STRING | REQUIRED |
| `revenue_monthly_fare` | FLOAT | NULLABLE |

That closes the section on running Spark in the cloud: we connected a
local Spark to Google Cloud Storage, created a managed Dataproc cluster,
submitted jobs to it from the UI and with `gcloud`, and finally wrote the
results directly to BigQuery.

The script is [`code/06_spark_sql_big_query.py`](code/06_spark_sql_big_query.py).
