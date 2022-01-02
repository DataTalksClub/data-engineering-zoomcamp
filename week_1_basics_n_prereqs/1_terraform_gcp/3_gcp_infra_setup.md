## GCP Infra Setup

### GCP Setup - P2
1. Download local setup/SDK: https://cloud.google.com/sdk/docs/quickstart

2. Authentication with Service account: https://cloud.google.com/docs/authentication/getting-started or https://cloud.google.com/docs/authentication/production

3. IAM for Service account (Roles: StorageAdmin, StorageObjectAdmin, Viewer)

4. Set env-var to point to your downloaded GCP auth-keys:
   ```
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   gcloud auth application-default login
   ```


### Commands

(Explanation TBD)

1. `cd data-engineering-zoomcamp/project/terraform`
2. `terraform init`
3. `terraform plan`
4. `terraform apply`


## References

* https://registry.terraform.io/providers/hashicorp/google/latest/docs
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
* (bigquery ?)
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
* https://www.terraform.io/language/settings/backends/gcs
* https://cloud.google.com/about/locations#europe
