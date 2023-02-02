from prefect_gcp import GcpCredentials
from prefect_gcp.cloud_storage import GcsBucket
import os
import json
# alternative to creating GCP blocks in the UI
# insert your own service_account_file path or service_account_info dictionary from the json file
# IMPORTANT - do not store credentials in a publicly available repository!

# export PROJECT_ID=magnetic-energy-375219
# gcloud config set project ${PROJECT_ID?}

GCP_PROJECT = os.environ.get('PROJECT_ID')
GCP_PROJECT = GCP_PROJECT if GCP_PROJECT is not None else 'magnetic-energy-375219'

# gcloud config set project magnetic-energy-375219



credentials_block = GcpCredentials(
    service_account_info={}  # enter your credentials info or use the file method.
)
credentials_block.save("zoom-gcp-creds", overwrite=True)


bucket_block = GcsBucket(
    gcp_credentials=GcpCredentials.load("zoom-gcp-creds"),
    bucket=f"prefect-de-zoomcamp_{GCP_PROJECT}",  # insert your  GCS bucket name
)

bucket_block.save("zoom-gcs", overwrite=True)
