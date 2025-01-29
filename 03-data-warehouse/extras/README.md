Quick hack to load files directly to GCS, without Airflow. Downloads csv files from https://nyc-tlc.s3.amazonaws.com/trip+data/ and uploads them to your Cloud Storage Account as parquet files.

1. Install pre-reqs (more info in `web_to_gcs.py` script)
2. Run: `python web_to_gcs.py`


Alternatively you could use kestra flow and table setup in this directory to download and upload the files  to your Cloud Storage Account as parquet files.

1. Copy and paste the zoomcamp_homework.yml flow to kestra and run it .
2. Copy and paste the bq_tables_setup into big query and run it to create the tables.

