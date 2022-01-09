(In Draft mode)

## Create infrastructure for our project with Terraform

### Project infrastructure modules in GCP:
* Google Cloud Storage (GCS): Data Lake
* BigQuery: Data Warehouse

### Setup Access
 
1. IAM for Service account (Roles: StorageAdmin, StorageObjectAdmin, Viewer)

2. Enable these APIs for your project:
   * https://console.cloud.google.com/apis/library/iam.googleapis.com
   * https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com
   
3. Please ensure `GOOGLE_APPLICATION_CREDENTIALS` env-var is set.
   ```shell
   export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"
   ```
    

### Execution

```shell
# Refresh service-account's auth-token for this session
gcloud auth application-default login

# Initialize state file (.tfstate)
terraform init

# Check changes to new infra plan
terraform plan -var="project=<your-project-id>"
```

```shell
# Create new infra
terraform apply -var="project=<your-project-id>"
```

```shell
# Delete infra after your work, to avoid costs on any running services
terraform destroy
```


## References

* https://registry.terraform.io/providers/hashicorp/google/latest/docs
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
* https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
* https://www.terraform.io/language/settings/backends/gcs
