# Batch Processing

## Units

1. [Introduction to Batch Processing](01-introduction-to-batch-processing.md) - Define batch processing, contrast it with streaming, and see where Spark fits among batch tools.
2. [Introduction to Spark](02-introduction-to-spark.md) - Explain what Spark is, which languages it supports, and when to use it instead of SQL on a data lake.
3. [Installing Spark](03-installing-spark.md) - Install Java and Spark on a Linux machine, then run spark-shell and PySpark with a local SparkSession.
4. [First Look at Spark/PySpark](04-first-look-at-spark.md) - Read a large CSV with an explicit schema, repartition it, and write it as parquet while watching the Spark UI.
5. [Spark DataFrames](05-spark-dataframes.md) - Work with Spark DataFrames, including parquet schemas, select and filter, lazy transformations versus actions, and UDFs.
6. [Preparing Yellow and Green Taxi Data](06-preparing-taxi-data.md) - Prepare yellow and green taxi CSVs for 2020 and 2021 by downloading them and rewriting them as typed parquet.
7. [SQL with Spark](07-sql-with-spark.md) - Combine green and yellow taxi data in Spark, register it as a temp table, and run the revenue report in Spark SQL.
8. [Anatomy of a Spark Cluster](08-anatomy-of-a-spark-cluster.md) - Describe the parts of a Spark cluster, including the driver, master, and executors, and why HDFS became less common.
9. [GroupBy in Spark](09-groupby-in-spark.md) - Trace how Spark executes a GROUP BY in two stages, with a per-partition aggregate and a reshuffle by key.
10. [Joins in Spark](10-joins-in-spark.md) - Compare sort merge joins for two large tables with broadcast joins for a large table and a small lookup table.
11. [Operations on Spark RDDs](11-operations-on-spark-rdds.md) - Rebuild the green revenue query with RDD filter, map, and reduceByKey, then convert the result back to a DataFrame.
12. [Spark RDD mapPartition](12-spark-rdd-mappartition.md) - Use mapPartitions to apply a model to each partition of a taxi dataset as a pandas DataFrame.
13. [Connecting to Google Cloud Storage](13-connecting-to-google-cloud-storage.md) - Upload taxi parquet files to Google Cloud Storage and configure a local Spark session to read from the bucket.
14. [Creating a Local Spark Cluster](14-creating-a-local-spark-cluster.md) - Run a standalone Spark cluster with a master and worker, convert the notebook to a script, and submit it with spark-submit.
15. [Setting up a Dataproc Cluster](15-setting-up-a-dataproc-cluster.md) - Create a Dataproc cluster and submit the Spark job from the web UI and with gcloud, after granting the needed role.
16. [Connecting Spark to BigQuery](16-connecting-spark-to-bigquery.md) - Write Spark job output directly to a BigQuery table using the BigQuery connector and a temporary GCS bucket.

Units 11 and 12 cover RDDs, which the module marks optional, as is the taxi-data
preparation in unit 6 and the guided Linux install in unit 3.

## Homework


# Community notes

<details>
<summary>Did you take notes? You can share them here</summary>

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/5_batch_processing.md)
* [Sandy's DE Learning Blog](https://learningdataengineering540969211.wordpress.com/2022/02/24/week-5-de-zoomcamp-5-2-1-installing-spark-on-linux/)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week5.md)
* [Alternative : Using docker-compose to launch spark by rafik](https://gist.github.com/rafik-rahoui/f98df941c4ccced9c46e9ccbdef63a03) 
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-5-batch-spark)
* [Notes by Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week5)
* [Notes by Oscar Garcia](https://github.com/ozkary/Data-Engineering-Bootcamp/tree/main/Step5-Batch-Processing)
* [Notes by HongWei](https://github.com/hwchua0209/data-engineering-zoomcamp-submission/blob/main/05-batch-processing/README.md)
* [2024 videos transcript](https://drive.google.com/drive/folders/1XMmP4H5AMm1qCfMFxc_hqaPGw31KIVcb?usp=drive_link) by Maria Fisher 
* [2025 Notes by Manuel Guerra](https://github.com/ManuelGuerra1987/data-engineering-zoomcamp-notes/blob/main/5_Batch-Processing-Spark/README.md)
* [2025 Notes by Gabi Fonseca](https://github.com/fonsecagabriella/data_engineering/blob/main/05_batch_processing/00_notes.md)
* [2025 Notes on Installing Spark on MacOS (with Anaconda + brew) by Gabi Fonseca](https://github.com/fonsecagabriella/data_engineering/blob/main/05_batch_processing/01_env_setup.md)
* [2025 Notes by Daniel Lachner](https://github.com/mossdet/dlp_data_eng/blob/main/Notes/05_01_Batch_Processing_Spark_GCP.pdf)
* [2026 Notes by Ajay Katte](https://github.com/mushroomsandchai/dtdez/tree/main/06_batch_processing/notes)
* [2026 Video PySpark installation on Windows (no pip install) by khanh](https://www.youtube.com/watch?v=8OYBW4Lwu60)
* Add your notes here (above this line)

</details>
