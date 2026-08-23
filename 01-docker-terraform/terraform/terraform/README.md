### Concepts
* [Terraform_overview](../1_terraform_overview.md)
* If you were unable to generate a service account keyfile due to organizational policies, refer to the instructions [below](#fallback)

### Execution

```shell
# Refresh service-account's auth-token for this session
gcloud auth application-default login

# Initialize state file (.tfstate)
terraform init

# Check changes to new infra plan
terraform plan -var="project=<your-gcp-project-id>"
```

```shell
# Create new infra
terraform apply -var="project=<your-gcp-project-id>"
```

```shell
# Delete infra after your work, to avoid costs on any running services
terraform destroy
```

### Warning
Remember to use a [proper gitignore](https://github.com/github/gitignore/blob/main/Terraform.gitignore) file before publishing your code on GitHub

### Fallback
1. Give yourself the token creator role on the pertinent service account
    ```bash
    gcloud iam service-accounts add-iam-policy-binding \
        <SERVICE_ACCOUNT_EMAIL> \
        --member="user:YOUR_EMAIL@gmail.com" \
        --role="roles/iam.serviceAccountTokenCreator"
    ```
2. Add the sections below the first block to your main terraform configuration
   ```terraform
    # Connect to gcp using ADC (identity verification)
    provider "google" {
      project = var.project
      region  = var.region
      zone    = var.zone
    }

    /* add these data blocks */
    
    # This data source gets a temporary token for the service account
    data "google_service_account_access_token" "default" {
      provider               = google
      target_service_account = "<SERVICE_ACCOUNT_EMAIL>"
      scopes                 = ["https://www.googleapis.com/auth/cloud-platform"]
      lifetime               = "3600s"
    }
    
    # This second provider block uses that temporary token and does the real work
    provider "google" {
      alias        = "impersonated"
      access_token = data.google_service_account_access_token.default.access_token
      project      = var.project
      region       = var.region
      zone         = var.zone
    }
   ```

3. Now, you can follow the instructions [above](#execution)
