---
video_url: https://www.youtube.com/watch?v=Yyz293hBVcQ
---
# Connecting to Google Cloud Storage

> [!WARNING]
> **Scaffold — the lesson text for this unit has not been written.**
> Everything on this page was carried over mechanically: the title, the video
> and the material that already existed in the repository. Nothing here
> explains the topic. Watch the video; do not read this page as the lesson.

<!-- SCAFFOLD-NO-WRITEUP -->

Uploading data to GCS:

```bash
gsutil -m cp -r pq/ gs://dtc_data_lake_de-zoomcamp-nytaxi/pq
```

Download the jar for connecting to GCS to any location (e.g. the `lib` folder):

**Note**: For other versions of GCS connector for Hadoop see [Cloud Storage connector ](https://cloud.google.com/dataproc/docs/concepts/connectors/cloud-storage#connector-setup-on-non-dataproc-clusters).

```bash
gsutil cp gs://hadoop-lib/gcs/gcs-connector-hadoop3-2.2.5.jar ./lib/
```

See the notebook with configuration in [`code/09_spark_gcs.ipynb`](code/09_spark_gcs.ipynb)

(Thanks Alvin Do for the instructions!)
