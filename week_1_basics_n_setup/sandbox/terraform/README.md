# Terraform overview

## Concepts

### Introduction

1. What is [Terraform](https://www.terraform.io)?
	* It's a tool for provisioning infrastructure resources.
	* Allows you to store, version control, and swap out different infrastructure configurations (eg test, dev, prod).
2. What is IaC?
   * Infrastructure-as-Code
   * build, change, and manage your infrastructure in a safe, consistent, and repeatable way by defining resource configurations that you can version, reuse, and share.
3. Some advantages
   * Infrastructure lifecycle management
   * Version control commits
   * Very useful for stack-based deployments, and with cloud providers such as AWS, GCP, Azure, K8S…
   * State-based approach to track resource changes throughout deployments


#### Files

* `main.tf`
* `variables.tf`
* Optional: `resources.tf`, `output.tf`
* `.tfstate`

#### Declarations
* `terraform`: configure basic Terraform settings to provision your infrastructure
   * `required_version`: minimum Terraform version to apply to your configuration
   * `backend`: stores Terraform's "state" snapshots, to map real-world resources to your configuration.
      * `local`: stores state file locally as `terraform.tfstate`
   * `required_providers`: specifies the providers required by the current module
* `provider`:
   * adds a set of resource types and/or data sources that Terraform can manage
   * The Terraform Registry is the main directory of publicly available providers from most major infrastructure platforms.
* `resource`
  * blocks to define components of your infrastructure
  * Project modules/resources: google_storage_bucket, google_bigquery_dataset, google_bigquery_table
* `variable` & `locals`
  * runtime arguments and constants


#### Execution steps
1. `terraform init`: 
    * Initializes & configures the backend, installs plugins/providers, & checks out an existing configuration from a version control 
2. `terraform plan`:
    * Matches/previews local changes against a remote state, and proposes an Execution Plan.
3. `terraform apply`: 
    * Asks for approval to the proposed plan, and applies changes to cloud
4. `terraform destroy`
    * Removes your stack from the Cloud


### Terraform Workshop to create GCP Infra
Continue [here](./terraform): `week_1_basics_n_setup/1_terraform_gcp/terraform`


### References
https://learn.hashicorp.com/collections/terraform/gcp-get-started


# Terraform Install

https://www.terraform.io/downloads

I looked into doing this in a container, but to authenticate anything, we'll need access to a web browser, which is much easier with a local install. 

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform
```

# Google Cloud Platform

Created a project

Set up a service account for the project, which is basically a service for the project. 

After creating the service, we can create keys.

Copy the json key file from downloads to a better location.

We also need to install the google cloud SDK. I looked into doing this in a container, but to authenticate anything, we'll need access to a web browser, which is much easier with a local install. 

```bash
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
sudo apt-get update && sudo apt-get install google-cloud-cli
gcloud init
```

Overwrite the environment variable set by the above `init` step.

```bash
export GOOGLE_APPLICATION_CREDENTIALS="<path/to/your/service-account-authkeys>.json"

# Refresh token/session, and verify authentication
gcloud auth application-default login
```

After setting that up, we will add more permissions to the service account we created for our project.
Back in the GCP web interface, go to the IAM page for our project and click the pencil icon (hover tooltip: "Edit principal"). The following steps aren't ideal for production, but they're fine for a first project. (In production, you'll want to define custom roles tailored to specific services)

Add the roles
* "Storage Admin" with the power to create and administrate buckets, 
* "Storage Object Admin" to administrate the objects in the buckets, and
* BigQuery Admin, to run big queries.

We'll also need to enable both of these APIs for our project, so that our local CLI can communicate with our project in the cloud.
* https://console.cloud.google.com/apis/library/iam.googleapis.com
* https://console.cloud.google.com/apis/library/iamcredentials.googleapis.com