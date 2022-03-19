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


## Configuring a VM instance

### Setting up an ssh key

Google's [Create ssh key documentation](https://cloud.google.com/compute/docs/connect/create-ssh-keys) 

Generate the key
```bash
ssh-keygen -t rsa -f ~/.ssh/<KEY_FILENAME> -C <USER> -b 2048
```
then you have to add the **public key** part of your ssh key to Google Cloud, but before you can do that, the GCP **Compute Engine API** must be enabled (just select **Compute Engine** from the **Resources** section of the [GCP Dashboard](https://console.cloud.google.com/home?project=dtc-de-course-344600) and then refresh). In the **Settings** group in the left-hand tray, select **Metadata** > click over to the **SSH Keys** tab > click the **Add SSH Key** button. Copy the contents of `~/.ssh/<KEY_FILENAME>.pub`, paste that into the webform field, and click save.

### Create Instance

Go back to the **VM instances** interface (it's the top option in the **Virtual Machines** group in the left-hand tray) and click the **Create Instance** button in the top row (if your window is too narrow, you might have to click the three-dots to see the option).

While updating settings, you'll see the hourly run cost of such a setup

Set the settings below
* Instance name: dtc-de-zoomcamp
* Region (and zone): us-central1
* Machine type: e2-standard-4 ($0.14/hr)
* Boot disk: Ubuntu 20.04LTS w 30GB persistant storage

Click **Create**, and it will take a bit to create. When it's ready, we'll SSH to its **External IP**.

### Connecting to the Instance

Using the **External IP** address from our instance's line in the VM Instances dashboard, we SSH into our VM, using our private key for authentication via the command below (with the bracked placeholders replaced with your real values, of course). NOTE: if you used an email address as your <USER> string when creating your SSH key, leave off the @-sign and email domain in your `ssh` connection string (eg if your <USER> string was "name@gmail.com", only use the "name" part).

```bash
ssh -i ~/.ssh/<KEY_FILENAME> <USER>@<EXTERNAL_IP>
```

That will provide a terminal in the container.

### Writing an SSH Config file

To make connecting easier, we can save ssh connection configurations to a file `~/.ssh/config` (the `ssh` program looks for that file).


```txt
Host <name-of-ssh-connection-config>
	HostName <EXTERNAL_IP>
	User <USER_STRING_WITHOUT_EMAIL_DOMAIN>
	IdentityFile ~/.ssh/<KEY_FILENAME>
```

then you can reduce your `ssh` command to just

```bash
ssh <name-of-ssh-connection-config>
```


## Setting up our instance.

### Installing Miniconda

Grab the installer download link for the latest version of [Miniconda](https://docs.conda.io/en/latest/miniconda.html) for your platform and desired python version, as well as the SHA256 hash value corresponding to that link.

At the time of writing, the latest python3.9 miniconda version is 4.11.0, and has the below link and SHA256. If you're following along at a later date, swap in your version, file name, and hash value as appropriate in the steps below.

version: https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh 
SHA256: 4ee9c3aa53329cd7a63b49877c0babb49b19b7e5af29807b793a76bdb1d362b4

Download the installer via

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.11.0-Linux-x86_64.sh
```

then confirm the file downloaded correctly, completely, and without any modification by a sneaky man-in-the-middle via

```bash
sha256sum Miniconda3-py39_4.11.0-Linux-x86_64.sh
4ee9c3aa53329cd7a63b49877c0babb49b19b7e5af29807b793a76bdb1d362b4  Miniconda3-py39_4.11.0-Linux-x86_64.sh
```

The hash values should match exactly (it's easy to quickly check by pasting the output into a text file, then copying the SHA256 from the download page, and pasting that into the text file right below the prior paste (as shown below)). If they don't match, don't execute the file.

```
4ee9c3aa53329cd7a63b49877c0babb49b19b7e5af29807b793a76bdb1d362b4  Miniconda3-py39_4.11.0-Linux-x86_64.sh
4ee9c3aa53329cd7a63b49877c0babb49b19b7e5af29807b793a76bdb1d362b4
```

If they do match you can install miniconda via 

```bash
bash Miniconda3-py39_4.11.0-Linux-x86_64.sh
```

* Press enter to get through the EULA then enter "yes" when prompted.
* When prompted about the install location, press enter to pick the default location.
* When asked if you want to run `conda init`, enter "yes"

That last step adds the directories containing the `conda` program to PATH (the locations a shell's executor checks when trying to find the program files corresponding to command-names), which termials load on startup, so you'll need to restart the terminal to get the `conda` command to work. You can do that by exiting and re-`ssh`ing in.






## Stopping your VM Instance

If you aren't using a compute instance and it's not running any calculations, you can save a lot of money by stopping the VM instance. 

To stop a VM instance, go to the **VM Instance** dashboard, click the three-dots for the VM instance you want to shut down, and click **Stop**. It will probably take 30 seconds to a minute to stop (90 seconds at the most, at which point GCP will kill it and it could cause memory loss), at which point the **Status** icon will show it's stopped and the **External IP** will show **None**.


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

Then, I initialized terraform

```bash
terraform init
```

## Types of terraform files

### `.terraform-version`

Defines the terraform version, 1 line is enough, e.g.

```
1.1.7
```

### main.tf

Many config examples can be found in [terraform provider docs](https://registry.terraform.io/browse/providers)

[Sample tutorial for GCP](https://learn.hashicorp.com/tutorials/terraform/google-cloud-platform-build?in=terraform/gcp-get-started)

```
terraform {
  required_version = ">= 1.0"
  backend "local" {}  # Can change from "local" to "gcs" (for google) or "s3" (for aws), if you would like to preserve your tf-state online
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}
```

Here we show a block defining a google project, or more accurately, pointing to the locations with data defining a google project. The `project` and `region` variables point to definitions in the `variables.tf` file, and the commented `credentials` variable points to a file with its path defined in the `variables.tf` file. 

Google Cloud products are available in many [regions](https://cloud.google.com/about/locations) and it's a good idea to use the same region for all of your applications components (to minimize latency), which is why we define `region` at a project level. 

```
provider "google" {
  project = var.project
  region = var.region
  credentials = file(var.credentials)  # Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
}

```

```

# Data Lake Bucket
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "data-lake-bucket" {
  name          = "${local.data_lake_bucket}_${var.project}" # Concatenating DL bucket & Project name for unique naming
  location      = var.region

  # Optional, but recommended settings:
  storage_class = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}

# DWH
# Ref: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.BQ_DATASET
  project    = var.project
  location   = var.region
}
```

## `variables.tf`

Define resources

```js
locals {
  data_lake_bucket = "dtc_data_lake"
}

variable "project" {
  description = "Your GCP Project ID"
}

variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default = "us-central1"
  type = string
}

variable "storage_class" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default = "STANDARD"
}

variable "BQ_DATASET" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  type = string
  default = "trips_data_all"
}
```

## Setting it up
After defining the project in terraform files, in a terminal, navigate to the location containing those files and enter

```bash
terraform init
```

This will create some hidden files (`.terraform.lock.hcl`, `.terraform.tfstate`, and maybe `.terraform.tfstate.backup`) that define the backend steps.

You can review the infrastructure plan via the command, which will ask you to enter any variables without default values,

```bash
terraform plan
```
and you can provide those variables (or override defaults) at call-time

```bash
# Check changes to new infra plan
terraform plan -var="project=<your-gcp-project-id>" -var="credentials=<path-to-you-project-key.json-file"
```

Note that `terraform plan` won't apply the displayed plan. To actually create the infrastructure, you have to use the `terraform apply` command, provide any undefined variables, and then enter `yes` when prompted.

```bash
# Create new infra
terraform apply -var="project=<your-gcp-project-id>" -var="credentials=<path-to-you-project-key.json-file"
```

If you want to ensure that the displayed plan is the one used in the `apply` step, you can save the plan by adding the `-out=<file_path>` flag to your `terrafrom plan` command to write it to a file, and then include that file_path in the `apply` command, as shown below. 

```bash
# Check changes to new infra plan
terraform plan -var="project=<your-gcp-project-id>" -var="credentials=<path-to-you-project-key.json-file" -out=<path-to-plan-file>

terraform apply <path-to-plan-file>
```