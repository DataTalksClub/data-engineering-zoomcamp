---
video_url: https://www.youtube.com/watch?v=Yyz293hBVcQ
---
# Connecting to Google Cloud Storage

So far our Spark jobs read parquet files from the local file system. In
this unit we move the data to Google Cloud Storage and configure our local
Spark to read from it. This is the first unit in the running-Spark-in-the-
cloud section: after this come creating a local Spark cluster and running
Spark on Dataproc.

The setup follows instructions written by Alvin Do - thanks, Alvin! We
walk through them step by step. The finished configuration is in
[`code/09_spark_gcs.ipynb`](code/09_spark_gcs.ipynb).


## Uploading the data to Google Cloud Storage

We already have a bucket from the Terraform setup in module one. The data
we produced in the previous units - the parquet files in `data/pq` and the
report - now moves there. `gsutil cp` copies files to Google Cloud
Storage, and since we are copying a folder with a lot of files, we add two
flags: `-r` for recursive, and `-m` for multi-threaded (parallel) upload,
which uses all the CPUs of the machine:

```bash
gsutil -m cp -r pq/ gs://dtc_data_lake_de-zoomcamp-nytaxi/pq
```

Uploading the parquet files takes a while - the folder holds 380 files,
1.1 GiB in total:

The terminal ends with the completed transfer:

```text
[2726/380 files][ 1.0 GiB/ 1.1 GiB] 97% Done
[380/380 files][ 1.1 GiB/ 1.1 GiB] 100% Done
```

When it finishes, the `pq` folder with the green and yellow parquet files
sits in the bucket.

## The GCS connector for Hadoop

Spark cannot read a `gs://` URL out of the box. When Spark sees a URI like

```
gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/green/...
```

it needs to know how to connect to Google Cloud Storage to fetch the
files. The piece that knows how to do this is the Cloud Storage connector
for Hadoop - a jar file, a Java library. You can ignore the Hadoop part of
the name: we just need to tell Spark where the jar is.

For other versions of the GCS connector for Hadoop see the
[Cloud Storage connector](https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage#connector-setup-on-non-dataproc-clusters)
documentation.

The connector is hosted on Google Cloud Storage itself, so we download it
with `gsutil` again. We need the `hadoop3` build - the Spark version we
installed in the setup unit was built for Hadoop 3 - and version 2.2.5 of
the connector:

```bash
mkdir lib
gsutil cp gs://hadoop-lib/gcs/gcs-connector-hadoop3-2.2.5.jar ./lib/
```

The `lib` folder is not a special location - we put the jar there to keep
it next to the code:

## Configuring the Spark session

Now the configuration. The notebook starts with a few extra imports: we
need `SparkConf` and `SparkContext` in addition to `SparkSession`.

Next we point Spark to our Google Cloud credentials. The path is the same
service-account key we created with Terraform in module one:

```python
credentials_location = '/home/alexey/.google/credentials/google_credentials.json'
```

Then we build the configuration. Instead of letting the session builder
create everything, we set it up explicitly:

```python
conf = SparkConf() \
    .setMaster('local[*]') \
    .setAppName('test') \
    .set("spark.jars", "./lib/gcs-connector-hadoop3-2.2.5.jar") \
    .set("spark.hadoop.google.cloud.auth.service.account.enable", "true") \
    .set("spark.hadoop.google.cloud.auth.service.account.json.keyfile",
         credentials_location)
```

We still run in `local[*]` mode with the app name `test`. The new parts
are the jar we just downloaded and the two settings that switch on the
service-account authentication with our key file.

With the configuration we create a Spark context, and through it we
configure the Hadoop layer that actually handles the `gs://` file system:

```python
sc = SparkContext(conf=conf)

hadoop_conf = sc._jsc.hadoopConfiguration()

hadoop_conf.set("fs.AbstractFileSystem.gs.impl",
                "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFS")
hadoop_conf.set("fs.gs.impl",
                "com.google.cloud.hadoop.fs.gcs.GoogleHadoopFileSystem")
hadoop_conf.set("fs.gs.auth.service.account.json.keyfile",
                credentials_location)
hadoop_conf.set("fs.gs.auth.service.account.enable", "true")
```

This is the part that says: when you see a file system that starts with
`gs`, use the implementation that comes from the connector jar, and use
these credentials.

Finally we create the session from the context - the same builder as
always, but reusing the configuration we just assembled:

```python
spark = SparkSession.builder \
    .config(conf=sc.getConf()) \
    .getOrCreate()
```

## Testing the connection

Now we read the green parquet files straight from the bucket:

```python
df_green = spark.read.parquet('gs://dtc_data_lake_de-zoomcamp-nytaxi/pq/green/*/*')
```

A simple `df_green.count()` confirms that it works - Spark connects to
Google Cloud Storage, downloads the parquet files and counts the rows:

That is all the configuration takes. Note that we only need this when we
run Spark ourselves - on a virtual machine or on a laptop. Later in this
section we use Dataproc, the managed Spark service on Google Cloud, and
there this configuration is not needed: a Dataproc cluster can already
talk to Google Cloud Storage out of the box.
