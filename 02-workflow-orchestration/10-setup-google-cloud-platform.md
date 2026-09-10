---
video_url: https://www.youtube.com/watch?v=TLGFAOHpOYM
---
# Setup Google Cloud Platform (GCP)

Before we start loading data to GCP, we need to set up the Google Cloud Platform.

First, adjust the following flow [`06_gcp_kv.yaml`](flows/06_gcp_kv.yaml) to include your service account, GCP project ID, BigQuery dataset and GCS bucket name (_along with their location_) as KV Store values:
- GCP_PROJECT_ID
- GCP_LOCATION
- GCP_BUCKET_NAME
- GCP_DATASET.


## Create GCP Resources
If you haven't already created the GCS bucket and BigQuery dataset in the first week of the course, you can use this flow to create them: [`07_gcp_setup.yaml`](flows/07_gcp_setup.yaml).

> [!WARNING]
> The `GCP_CREDS` service account contains sensitive information. Ensure you keep it secure and do not commit it to Git. Keep it as secure as your passwords.

## Resources
- [Set up Google Cloud Service Account in Kestra](https://go.kestra.io/de-zoomcamp/google-sa)
