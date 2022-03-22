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

### Installing Docker

Before we can install anything via Ubuntu/Debian's `apt` (or `apt-get`) package manager, we need to update the list of package metadata.

```bash
sudo apt update
````
Then you can install things via `apt` or `apt-get`, like `docker.io` as shown in the below command. 

```bash
sudo apt-get install docker.io
```

I'm not sure why Alexey went with docker.io in the video, the [Docker Ubuntu install instructions](https://docs.docker.com/engine/install/ubuntu/#uninstall-old-versions) describe that as an old version to be installed, so I'm going to follow Docker instructions.

```bash
sudo apt-get remove docker.io docker

sudo apt-get install ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Then, after setting up docker's `gpg` key (so I can know if the executable file the machine receives is valid), we can install `Docker Engine` via

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

After that completes, you can confirm the installation via 

```bash
sudo docker run hello-world
```

#### Docker-without-sudo

The standard Docker install runs things as root, which grants it great and terrible power. Alexey showed a guide called [docker-without-sudo](https://github.com/sindresorhus/guides/blob/main/docker-without-sudo.md) that contains a minimal set of instructions to setup that configuration (included below then executed).


##### Run Docker commands without sudo
1. Add the `docker` group if it doesn't already exist

  ```console
  $ sudo groupadd docker
  ```

2. Add the connected user `$USER` to the docker group
  Optionally change the username to match your preferred user.

  ```console
  $ sudo gpasswd -a $USER docker
  ```

  **IMPORTANT**: Log out and log back in so that your group membership is re-evaluated.

3. Restart the `docker` daemon

  ```console
  $ sudo service docker restart
  ```

  If you are on Ubuntu 14.04-15.10, use `docker.io` instead:

  ```console
  $ sudo service docker.io restart
  ```

### Docker-compose install

Go to the [releases](https://github.com/docker/compose/releases/tag/v2.3.3) page for the docker/compose GitHub repo, and copy the download path for the most revent version (for me, that's v2.3.3) for linux and for systems with `x86_64` processor architecture. 

link: https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64
SHA256: d31e90dda58e21a6463cb918868421b4b58c32504b01b1612d154fe6a9167a91  docker-compose-linux-x86_64

Checking

```bash
user@host:~$ mkdir bin && cd bin
user@host:~/bin$ wget https://github.com/docker/compose/releases/download/v2.3.3/docker-compose-linux-x86_64
user@host:~/bin$ sha256sum docker-compose-linux-x86_64 
d31e90dda58e21a6463cb918868421b4b58c32504b01b1612d154fe6a9167a91  docker-compose-linux-x86_64
```
d31e90dda58e21a6463cb918868421b4b58c32504b01b1612d154fe6a9167a91

It checks out.

```bash
(base) user@host:~/bin$ ls -la
total 25404
drwxrwxr-x  2 user user     4096 Mar 21 19:23 .
drwxr-xr-x 10 user user     4096 Mar 21 19:23 ..
-rw-rw-r--  1 user user 26005504 Mar  9 13:53 docker-compose-linux-x86_64
````

As you can see from the `ls -la` command above, that file only has `rw` permissions. As we've confirmed (via the checksums) that we've received a perfect copy of the file from the `compose` repo,  I'm comfortable giving it permission to be executed.

```bash
(base) user@host:~/bin$ chmod +x docker-compose-linux-x86_64 
(base) user@host:~/bin$ ls -la
total 25404
drwxrwxr-x  2 user user     4096 Mar 21 19:23 .
drwxr-xr-x 10 user user     4096 Mar 21 19:23 ..
-rwxrwxr-x  1 user user 26005504 Mar  9 13:53 docker-compose-linux-x86_64
```

And we can execute it via

```bash
(base) user@host:~/bin$ ./docker-compose-linux-x86_64
```

But that only works from this directory. We'll add this `/bin` directory to path to make the files in `/bin` accessible everywhere.

Open up the `~/.bashrc` file

```bash
nano ~/.bashrc
```

Then scroll down to the end of the file and append

```bash
export PATH="${HOME}/bin:${PATH}"
```
Then save (ctrl+o), exit (ctrl+x), and restart the bash terminal

```bash
source .bashrc
````

Also, I don't want to have the `-linux-x86_64` on the end, so I'll rename that file.

```bash
user@host:~/bin$ mv docker-compose-linux-x86_64 docker-compose
```

### Downloading the DTC Data Engineering Zoomcamp repo

Take the `https` clone option from the [repo page](https://github.com/DataTalksClub/data-engineering-zoomcamp) and clone it. I'm going download my fork of that repo.

```bash
git clone https://github.com/MattTriano/data-engineering-zoomcamp.git
```

I'm writing this in a branch I've named `mt_week1`, which you can see (along with all other branches) by entering 

```bash
git branch -a
````
and you can copy that to your local machine by the command

```bash
git fetch origin mt_week1:mt_week1
```
(it pulls the branch `mt_week1` from its origin (my fork), and put it in a local branch named `mt_week1`).

Then you can check it out via the typical `git checkout mt_week1` type command.


### Loading db:

I'll use the scripts I already put together to load data into the db.

First, I'll navigate to my the directory with my docker-compose that defines my application and spin it up:

```bash
(base) user@host:~/bin$ cd ~/data-engineering-zoomcamp/week_1_basics_n_setup/sandbox/docker/containerized_pg
(base) user@host:~/.../containerized_pg$ docker-compose up --build 
```

Then, in another ssh terminal, I'll make a new conda env and install `pgcli`

```bash
conda config --add channels conda-forge
conda config --set channel_priority strict
conda create -n de_env python=3.9
conda activate de_env
(de_env) ...$ conda install -c conda-forge pgcli
```

If I had already ingested data, I could access it via

```bash
(de_env) user@host:~/...$ pgcli -h localhost -U root -d ny_taxi
```

but our docker-compose script just spins up the infrastructure and Alexey just ingests data through a notebook, so I'll skip that as we know how to do that (and we'll refactor our workflow to use Airflow soon).


### Installing Terraform in VM

From the [Terraform downloads page](https://www.terraform.io/downloads), copy the download link for the AMD64 linux binary, and `wget` that into `/bin`. Also, calculate the sha256 hash for the zipped file after `wget`-ing it.


```bash
(de_env) user@host:~/bin$ wget https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip
(de_env) user@host:~/bin$ sha256sum terraform_1.1.7_linux_amd64.zip 
e4add092a54ff6febd3325d1e0c109c9e590dc6c38f8bb7f9632e4e6bcca99d4  terraform_1.1.7_linux_amd64.zip
```

The `downloads` page also has a link to download a file of SHA256 checksum hashes for the different available builds. Download that file and pull out the hash corresponding to the binary  you downloaded. From that file of sha256 hashes, here's the one for the file at the URL above.

```bash
e4add092a54ff6febd3325d1e0c109c9e590dc6c38f8bb7f9632e4e6bcca99d4  terraform_1.1.7_linux_amd64.zip
```

They match, so we're good.

We need to unzip that file before it can be executed, so install `unzip`, unzip the file, then remove the zipped file.

```bash
(de_env) user@host:~/bin$ sudo apt install unzip
(de_env) user@host:~/bin$ unzip terraform_1.1.7_linux_amd64.zip 
(de_env) user@host:~/bin$ rm terraform_1.1.7_linux_amd64.zip 
```

Confirm it's executable by checking the version. 

```bash
(de_env) user@host:~/bin$ terraform version
Terraform v1.1.7
on linux_amd64
```

Now let's try to apply our `terraform` plan. We'll need to get our credential file on the VM though (and I `.gitignore`'d that for security). We can use `sftp` to securely put that file on our VM.

In a terminal on your local machine, navigate to the location containing the file to `put` on the VM, then start an `sftp` (Secure File Transfer Protocol) connection. You can do this using the `Host` name you defined in your `~/.ssh/config` file.

```bash
local_user@local_host:~/.../secret_secrets$ sftp <name-of-ssh-connection-config>
Connected to <name-of-ssh-connection-config>.
sftp> ls
Miniconda3-py39_4.11.0-Linux-x86_64.sh bin data-engineering-zoomcamp
miniconda3 snap                                                   
sftp> cd data-engineering-zoomcamp
sftp> mkdir secret_secrets && cd secret_secrets
sftp> put <google_cloud_authentication_file>.json
sftp> exit
```

With that 

```bash
# Check changes to new infra plan
terraform plan -var="project=<your-gcp-project-id>" -var="credentials=<path-to-you-project-key.json-file"
```







### Configuring VS-Code 
If you're using VS-Code, you can install the "Remote - SSH" extension to connect to our VM more conveniently. [See video for more](https://youtu.be/ae-CV2KfoN0?t=1126)


To install VS-Code on ubuntu, 

```bash
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
```

Then update the package cache (and install `apt-transport-https` if it's not already on your machine) via

```bash
sudo apt install apt-transport-https
sudo apt update
sudo apt install code 
```

















## Stopping your VM Instance

If you aren't using a compute instance and it's not running any calculations, you can save a lot of money by stopping the VM instance. 

To stop a VM instance, go to the **VM Instance** dashboard, click the three-dots for the VM instance you want to shut down, and click **Stop**. It will probably take 30 seconds to a minute to stop (90 seconds at the most, at which point GCP will kill it and it could cause memory loss), at which point the **Status** icon will show it's stopped and the **External IP** will show **None**.

You can also shut things down from the terminal by entering 

```bash
sudo shutdown
```



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
    }terraform plan -var="project=dtc-de-course-344600" -var="credentials=/home/matt.triano/data-engineering-zoomcamp/credentials/dtc-de-course-344600-cb6fe6139243.json"
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