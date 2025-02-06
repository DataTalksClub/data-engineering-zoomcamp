## Model deployment
[Tutorial](https://cloud.google.com/bigquery-ml/docs/export-model-tutorial)
### Steps
- gcloud auth login
- bq --project_id robotic-incline-449301-g8 extract -m zoomcamp.tip_model gs://huiling-qiao-kestra-bucket/tip_model
- mkdir /tmp/model
- gsutil cp -r gs://huiling-qiao-kestra-bucket/tip_model /tmp/model
- mkdir -p serving_dir/tip_model/1
- cp -r /tmp/model/tip_model/* serving_dir/tip_model/1
- docker pull tensorflow/serving

(other commands tried)
- docker pull --platform=linux/arm64 tensorflow/serving
- docker pull tensorflow/serving:latest-arm64

(not working for me, +exit 132)
- docker run -p 8501:8501 --mount type=bind,source=`pwd`/serving_dir/tip_model,target=/models/tip_model -e MODEL_NAME=tip_model --platform=linux/arm64 -t tensorflow/serving &
- curl -d '{"instances": [{"passenger_count":1, "trip_distance":12.2, "PULocationID":"193", "DOLocationID":"264", "payment_type":"2","fare_amount":20.4,"tolls_amount":0.0}]}' -X POST http://localhost:8501/v1/models/tip_model:predict
- http://localhost:8501/v1/models/tip_model