---
video_url: https://www.youtube.com/watch?v=HXBwSlXo5IA
---
# Creating a Local Spark Cluster

> [!WARNING]
> **Scaffold — the lesson text for this unit has not been written.**
> Everything on this page was carried over mechanically: the title, the video
> and the material that already existed in the repository. Nothing here
> explains the topic. Watch the video; do not read this page as the lesson.

<!-- SCAFFOLD-NO-WRITEUP -->

Creating a stand-alone cluster ([docs](https://spark.apache.org/docs/latest/spark-standalone.html)):

```bash
./sbin/start-master.sh
```

Creating a worker:

```bash
URL="spark://de-zoomcamp.europe-west1-b.c.de-zoomcamp-nytaxi.internal:7077"
./sbin/start-slave.sh ${URL}

# for newer versions of spark use that:
#./sbin/start-worker.sh ${URL}
```

Turn the notebook into a script:

```bash
jupyter nbconvert --to=script 06_spark_sql.ipynb
```

Edit the script and then run it:

```bash
python 06_spark_sql.py \
    --input_green=data/pq/green/2020/*/ \
    --input_yellow=data/pq/yellow/2020/*/ \
    --output=data/report-2020
```

Use `spark-submit` for running the script on the cluster

```bash
URL="spark://de-zoomcamp.europe-west1-b.c.de-zoomcamp-nytaxi.internal:7077"

spark-submit \
    --master="${URL}" \
    06_spark_sql.py \
        --input_green=data/pq/green/2021/*/ \
        --input_yellow=data/pq/yellow/2021/*/ \
        --output=data/report-2021
```

The script is [`code/06_spark_sql.py`](code/06_spark_sql.py).
