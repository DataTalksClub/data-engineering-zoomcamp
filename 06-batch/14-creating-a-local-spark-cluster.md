---
video_url: https://www.youtube.com/watch?v=HXBwSlXo5IA
---
# Creating a Local Spark Cluster

In this unit we take the Spark SQL job from the previous units out of the
notebook: we turn the notebook into a Python script, create a standalone
Spark cluster with a master and a worker, and submit the job to it with
`spark-submit`. Even though we run everything on the same machine, this is
the same flow you would use to submit jobs to a real cluster, including
the managed one we create in the next unit.

## The notebook was a cluster all along

When we create a SparkSession with `local[*]` in a notebook, Spark starts
a local cluster behind the scenes and our notebook connects to it - the
URL is `local[*]`, and the web UI lives on port 4040. When we shut the
kernel down, that cluster disappears with it.

That is convenient for experimenting, but it ties the cluster lifetime to
the notebook. To schedule this job later - for example from Airflow - we
need a cluster that exists independently of any notebook, and a script we
can submit to it.

## Starting a master

Spark ships with scripts for running a standalone cluster
(see the [Spark standalone docs](https://spark.apache.org/docs/latest/spark-standalone.html)).
From the Spark home directory, start a master:

```bash
./sbin/start-master.sh
```

The master has a web UI, but unlike the notebook-created cluster it is not
on port 4040 - a standalone master listens on port 8080. Open it in the
browser and you see the master with no workers connected yet:

The stable parts of the initial master view are:

| Master UI check | Expected result |
|---|---|
| Web UI port | `8080` |
| Status | `ALIVE` |
| Workers | none registered |
| Applications | none yet |
| Master connection URL | `spark://<master-host>:7077` |

The master URL is shown at the top of the UI as
`spark://<master-host>:7077`. This is the address that workers and
applications use to connect. Replace `<master-host>` with the hostname or
address printed by your own master.

## Connecting to the master

We can point our notebook at this master instead of `local[*]`:

```python
master = "spark://<master-host>:7077"

spark = SparkSession.builder \
    .appName('test') \
    .master(master) \
    .getOrCreate()
```

Running a cell now connects the notebook to the standalone master - the
application shows up in the master UI.

## Adding a worker

If we run a job now, it hangs with this warning:

```
Initial job has not accepted any resources; check your cluster UI to
ensure that workers are registered and have sufficient resources
```

The reason is simple: we started a master but zero workers. A master only
coordinates - the actual execution happens in workers, and we have none.
In another terminal, still in the Spark directory, start one:

```bash
URL="spark://<master-host>:7077"
./sbin/start-slave.sh ${URL}

# for newer versions of spark use that:
#./sbin/start-worker.sh ${URL}
```

Our Spark version is older, where a worker was called a slave - on newer
versions the script is `start-worker.sh`. After starting it, the worker
appears in the master UI. The stable parts of that next view are:

| Master UI check | Expected result |
|---|---|
| Workers | one worker registered |
| Application state | the pending job can receive resources and run |
| Runtime identifiers | host, IP, worker ID, application ID, and user values are local and omitted |

Now the pending job gets resources and executes. The notebook application
is connected to a real cluster with one worker.

## Turning the notebook into a script

Jupyter can convert a notebook to a plain Python script with nbconvert:

```bash
jupyter nbconvert --to=script 06_spark_sql.ipynb
```

The generated `06_spark_sql.py` needs a small cleanup: remove the `In
[...]` comments and the magic lines, keep the imports and the SparkSession
setup. In the video we also replace the generated column list with an
explicit `common_columns` list, which reads better in a script.

If we run the script right away with `python 06_spark_sql.py`, it connects
to the master and starts executing. But look at the master UI: the job
sits again at "Initial job has not accepted any resources". This time the
cause is different - the notebook application is still connected and took
all the available cores, so there is nothing left for the script. Shutting
down the notebook kernel frees the cores, and the script runs through.

## Making the script configurable

The script hardcodes its input and output paths. For a job we want to
schedule - run it for one month, or one year, or a different output -
those paths should come from the command line. We use `argparse`, the same
package we used for the ingestion script in module one:

```python
import argparse

parser = argparse.ArgumentParser()

parser.add_argument('--input_green', required=True)
parser.add_argument('--input_yellow', required=True)
parser.add_argument('--output', required=True)

args = parser.parse_args()

input_green = args.input_green
input_yellow = args.input_yellow
output = args.output
```

The parsed arguments replace the hardcoded paths in the script. Now we can
run the same job for any period, for example 2020 only:

```bash
python 06_spark_sql.py \
    --input_green=data/pq/green/2020/*/ \
    --input_yellow=data/pq/yellow/2020/*/ \
    --output=data/report-2020
```

It finishes quickly - there is not much 2020 data - and the report lands
in `data/report-2020`.

## Submitting with spark-submit

Hardcoding the master URL inside the script is still not practical: the
same script may need to run against a local cluster today and a different
cluster from Airflow tomorrow. And there are other things we may want to
configure per-run, like how many executors to use and how much memory
they get. In practice this configuration lives outside the script, and
the tool for supplying it is `spark-submit`, which ships with Spark:

```bash
URL="spark://<master-host>:7077"

spark-submit \
    --master="${URL}" \
    06_spark_sql.py \
        --input_green=data/pq/green/2021/*/ \
        --input_yellow=data/pq/yellow/2021/*/ \
        --output=data/report-2021
```

Everything before the Python file is the configuration for Spark - the
master, and optionally things like executor memory or the number of
cores. Everything after the file name is passed to the job itself, so our
`argparse` arguments go at the end.

This is the way you submit Spark jobs in practice, and it is also how you
would wire them into Airflow later. When it finishes, `data/report-2021`
appears next to the 2020 report - same script, same cluster, different
parameters.

The full script is [`code/06_spark_sql.py`](code/06_spark_sql.py).

## Stopping the cluster

One thing to remember: when you are done, stop the worker and the master
with the matching scripts from the same `sbin` directory:

```bash
./sbin/stop-slave.sh ${URL}   # ./sbin/stop-worker.sh on newer versions
./sbin/stop-master.sh
```

After that nothing is running, and trying to connect gives an error - the
cluster is really gone.
