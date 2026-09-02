---
video_url: https://www.youtube.com/watch?v=BjARzEWaznU
---
# Deploying a Machine Learning Model from BigQuery

> [!WARNING]
> **Scaffold — the lesson text for this unit has not been written.**
> The steps below are real and were carried over from the module's former
> `02-model-deployment.md`, but nothing on this page explains what they do or
> why. Watch the video; do not read this page as the lesson.

<!-- SCAFFOLD-NO-WRITEUP -->

## Steps to extract and deploy the model with Docker

[Google's tutorial](https://cloud.google.com/bigquery-ml/docs/export-model-tutorial)

Export the model from BigQuery to Cloud Storage and pull it down:

```bash
gcloud auth login
bq --project_id taxi-rides-ny extract -m nytaxi.tip_model gs://taxi_ml_model/tip_model
mkdir /tmp/model
gsutil cp -r gs://taxi_ml_model/tip_model /tmp/model
```

Lay it out the way TensorFlow Serving expects and run the server:

```bash
mkdir -p serving_dir/tip_model/1
cp -r /tmp/model/tip_model/* serving_dir/tip_model/1
docker pull tensorflow/serving
docker run -p 8501:8501 \
  --mount type=bind,source=`pwd`/serving_dir/tip_model,target=/models/tip_model \
  -e MODEL_NAME=tip_model -t tensorflow/serving &
```

Call it:

```bash
curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' \
  -X POST http://localhost:8501/v1/models/tip_model:predict
```

Model metadata is at `http://localhost:8501/v1/models/tip_model`.
