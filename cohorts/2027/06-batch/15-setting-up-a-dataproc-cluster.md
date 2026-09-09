---
video_url: https://www.youtube.com/watch?v=osAiAYahvh8
---
# Setting up a Dataproc Cluster

In this unit we finally move Spark itself to the cloud: we create a
Dataproc cluster in Google Cloud and run the Spark job from the previous
units on it, first through the web UI and then from the terminal with the
`gcloud` SDK. Dataproc - most likely short for data processing - is
Google Cloud's managed Spark service: it creates the master and workers
for us, and we only submit jobs to it.

## Creating the cluster

In the Google Cloud console, open Dataproc. The first time, it asks you to
enable the API - one click. Then click create cluster and configure it:

- Name: `<cluster-name>`.
- Region and zone: pick the region where your bucket lives, so the cluster
  is close to the data.
- Cluster type: in practice you would use standard, one master plus
  several workers. Since we are just experimenting and our dataset is not
  large, single node is enough.
- Under additional components, select the Jupyter notebook component - it
  lets you run experiments right on the cluster - and Docker, which we
  will use in a later section.

The stable parts of the create-cluster form are:

| Setting | Value |
|---|---|
| Cluster name | `<cluster-name>` |
| Region and zone | the region and zone where the bucket lives |
| Cluster type for this experiment | single node |
| Additional components | Jupyter Notebook and Docker |
| Machine types | defaults |

Everything else - the machine types of the master and the workers - stays
at the defaults. Click create, and after a few minutes the cluster is
running. Dataproc created a virtual machine for it behind the scenes; you
can see it in the Compute Engine section. We do not need to connect to it
- we only submit jobs to the cluster.

One thing we do not need anymore: the GCS connector setup from a few
units back. A Dataproc cluster can already access Google Cloud Storage
out of the box. That configuration is only for Spark running on your own
machine or an unconfigured virtual machine.

## Submitting a job from the web UI

Dataproc needs the job script somewhere it can read - we upload it to our
bucket, into a `code` folder. In practice you would use a separate bucket
for code, but for simplicity we put it into the same one:

```bash
BUCKET="<bucket-name>"
gsutil -m cp -r 06_spark_sql.py "gs://${BUCKET}/code/06_spark_sql.py"
```

Remember that in the previous unit we removed the hardcoded master from
the script. That matters here: when Dataproc runs the job, it sets the
master itself.

Open the cluster, click submit job, and fill in the form:

| Form field | Value |
|---|---|
| Job type | `PySpark` |
| Main Python file | `gs://<bucket-name>/code/06_spark_sql.py` |
| Dependencies and jar files | none |
| `--input_green` | `gs://<bucket-name>/pq/green/2021/*/` |
| `--input_yellow` | `gs://<bucket-name>/pq/yellow/2021/*/` |
| `--output` | `gs://<bucket-name>/report-2021` |

Submit and wait. The job page shows the driver output while it runs; when
it finishes, the result is in the bucket: a `report-2021` folder with the
parquet files of the monthly revenue report - computed by the cluster we
just created.

## Submitting a job with gcloud

The web UI is fine for trying things out, but we would not drive
production this way - you cannot easily submit a job from Airflow by
clicking buttons. There are three ways to submit a job to a Dataproc
cluster: the web UI, the Google Cloud SDK, and the REST API. The job
details page shows the equivalent REST call for what we just did, and
from it we can read the pieces we need: the cluster name, the Python file
and the arguments.

The SDK way is documented on the
[submitting a job](https://cloud.google.com/dataproc/docs/guides/submit-job#dataproc-submit-job-gcloud)
page. From the terminal of the virtual machine:

```bash
CLUSTER_NAME="<cluster-name>"
REGION="<bucket-region>"
BUCKET="<bucket-name>"

gcloud dataproc jobs submit pyspark \
    --cluster="${CLUSTER_NAME}" \
    --region="${REGION}" \
    "gs://${BUCKET}/code/06_spark_sql.py" \
    -- \
        --input_green="gs://${BUCKET}/pq/green/2020/*/" \
        --input_yellow="gs://${BUCKET}/pq/yellow/2020/*/" \
        --output="gs://${BUCKET}/report-2020"
```

Everything before the double minus configures the submission - cluster,
region, script - and everything after the double minus is passed to the
job itself, exactly like with `spark-submit` in the previous unit. Here
we run the job for 2020.

## Fixing the permissions

The first attempt fails with permission denied: not authorized to request
the resource. The reason is that we use one service account for
everything in this course - the one Terraform set up in module one - and
it has no permission to submit Dataproc jobs.

In a real project you would keep the roles separate: a powerful role for
Terraform, and a narrow role for the workers and schedulers that only
allows what they need - submitting Dataproc jobs, accessing buckets, and
so on. To keep the course simple we just add a role to the same service
account: open IAM & admin, find the account, and add the Dataproc
Administrator role.


With the policy updated, run the same `gcloud` command again. Now it goes
through: the job is submitted, the terminal shows the same driver output
we saw in the web UI, and it finishes. Run it once more for a different
year to see the parameterization at work - the 2020 report lands next to
the 2021 one in the bucket.

The stable object layout is:

```text
<bucket-name>/
├── code/
├── pq/
├── report-2020/
└── report-2021/
```

When we wire this into Airflow later, the simplest possible approach is a
BashOperator that runs exactly this `gcloud` command; there are also
dedicated Dataproc operators.

## What is still missing

We now have the full loop: read the taxi data from Google Cloud Storage,
process it on a Spark cluster, and write the report back to Google Cloud
Storage. For the projects, though, you probably want the results in a data
warehouse, not in a bucket - so you can build dashboards on them. You
could create an external table over the parquet files and copy them into
a BigQuery table, but there is a more direct way: Spark can write
straight to BigQuery. That is the next unit.
