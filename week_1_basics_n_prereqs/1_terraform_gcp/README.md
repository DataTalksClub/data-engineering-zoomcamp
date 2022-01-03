## Local Setup for Terraform and GCP

### Terraform

Installation: https://www.terraform.io/downloads

### GCP

For this course, we'll use a free version (upto EUR 300 credits). 

1. Create an account with your Google email ID 
2. Setup your first [project](https://console.cloud.google.com/), eg. "DTC DE Course", and note down the "Project ID"
3. Setup [service account & authentication](https://cloud.google.com/docs/authentication/getting-started) for this project, and download auth-keys (.json).
4. Download [SDK](https://cloud.google.com/sdk/docs/quickstart) for local setup
5. Set environment variable to point to your downloaded GCP auth-keys:
   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   
   # Refresh token, and verify authentication
   gcloud auth application-default login
   ```

### Workshop
Continue [here](../../project/terraform): `data-engineering-zoomcamp/project/terraform`
