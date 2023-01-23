## GCP Overview

[Video](https://www.youtube.com/watch?v=18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=2)

### Project infrastructure modules in GCP:

- Google Cloud Storage (GCS): Data Lake
- BigQuery: Data Warehouse

(Concepts explained in Week 2 - Data Ingestion)

### Initial Setup

For this course, we'll use a free version (upto EUR 300 credits).

1. Create an account with your Google email ID
2. Setup your first [project](https://console.cloud.google.com/) if you haven't already
   - eg. "DTC DE Course", and note down the "Project ID" (we'll use this later when deploying infra with TF)
3. Setup [service account & authentication](https://cloud.google.com/docs/authentication/getting-started) for this project
   - Grant `Viewer` role to begin with.
   - Download service-account-keys (.json) for auth.
4. Download [SDK](https://cloud.google.com/sdk/docs/quickstart) for local setup
5. Set environment variable to point to your downloaded GCP keys:

   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="/home/amunoz/Descargas/dtc-de-375315-862d6f63279d.json"

   # Refresh token/session, and verify authentication
   gcloud auth application-default login
   ```

### Setup for Access

1. [IAM Roles](https://cloud.google.com/storage/docs/access-control/iam-roles) for Service account:
   - Go to the _IAM_ section of _IAM & Admin_ https://console.cloud.google.com/iam-admin/iam
   - Click the _Edit principal_ icon for your service account.
   - Add these roles in addition to _Viewer_ : **Storage Admin** + **Storage Object Admin** + **BigQuery Admin**
2. Enable these APIs for your project:
   - https://console.cloud.google.com/apis/library/iam.googleapis.com
   - https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com
3. Please ensure `GOOGLE_APPLICATION_CREDENTIALS` env-var is set.
   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="/home/amunoz/Descargas/dtc-de-375315-605c8fd79018.json"
   ```

### Terraform Workshop to create GCP Infra

Continue [here](./terraform): `week_1_basics_n_setup/1_terraform_gcp/terraform`
