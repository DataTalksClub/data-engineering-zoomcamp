## GCP and Terraform on Windows

You don't need these instructions if you use WSL. It's only for "plain Windows" 

### Google Cloud SDK

* For this tutorial, you'll need a Linux-like environment, e.g. [GitBash](https://gitforwindows.org/), [MinGW](https://www.mingw-w64.org/) or [cygwin](https://www.cygwin.com/)
  * Power Shell should also work, but will require adjustments 
* Download SDK in zip: https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip
  * source: https://cloud.google.com/sdk/docs/downloads-interactive
* Unzip it and run the `install.sh` script

When installing it, you might see something like that:

```
The installer is unable to automatically update your system PATH. Please add
  C:\tools\google-cloud-sdk\bin
```

* To fix that, adjust your `.bashrc` to include this in `PATH` ([instructions](https://unix.stackexchange.com/questions/26047/how-to-correctly-add-a-path-to-path))
* You can also do it system-wide ([instructions](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7))

Now we need to point it to correct Python installation. Assuming you use [Anaconda](https://www.anaconda.com/products/individual):

```bash
export CLOUDSDK_PYTHON=~/Anaconda3/python
```

Now let's check that it works:

```bash
$ gcloud version
Google Cloud SDK 367.0.0
bq 2.0.72
core 2021.12.10
gsutil 5.5
```

### Google Cloud SDK Authentication 

* Now create a service account and generate keys like shown in the videos
* Download the key and put it to some location, e.g. `.gc/ny-rides.json`
* Set `GOOGLE_APPLICATION_CREDENTIALS` to point to the file

```bash
export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/ny-rides.json
```

Now authenticate: 

```bash
gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS
```

Alternatively, you can authenticate using OAuth like shown in the video

```bash
gcloud auth application-default login
```

If you get a message like `quota exceeded`

> WARNING:
> Cannot find a quota project to add to ADC. You might receive a "quota exceeded" or "API not enabled" error. 
> Run `$ gcloud auth application-default set-quota-project` to add a quota project.

Then run this:

```bash
PROJECT_NAME="ny-rides-alexey"
gcloud auth application-default set-quota-project ${PROJECT_NAME}
```


### Terraform 

* [Download Terraform](https://www.terraform.io/downloads)
* Put it to a folder in [PATH](https://gist.github.com/nex3/c395b2f8fd4b02068be37c961301caa7)
* Go to the location with Terraform files and initialize it

```bash
terraform init
```

Optionally you can configure your terraform files (`variables.tf`) to include your project id:

```bash
variable "project" {
  description = "Your GCP Project ID"
  default = "ny-rides-alexey"
  type = string
}
```

* Now [follow the instructions](1_terraform_overview.md#execution-steps)
  * Run `terraform plan`
  * Next, run `terraform apply`

If you get an error like that:

> Error: googleapi: Error 403: terraform@ny-rides-alexey.iam.gserviceaccount.com does not have
> storage.buckets.create access to the Google Cloud project., forbidden


Then you need to give your service account all the permissions. Make sure you follow the instructions in the videos 

* You can also use [this file](https://docs.google.com/document/d/e/2PACX-1vSZapy7gIj0TP-EFzub2OpAlAkuifGEVJ4XpkA1RvxZ45NjiQi29b6OhLuetdXXHWAn2lbbKxnbzMdd/pub), but it doesn't list all the required permissions
