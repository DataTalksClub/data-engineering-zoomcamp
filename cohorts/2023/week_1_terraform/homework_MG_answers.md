## Week 1 Homework

In this homework we'll prepare the environment by creating resources in GCP with Terraform.

In your VM on GCP install Terraform. Copy the files from the course repo
[here](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/week_1_basics_n_setup/1_terraform_gcp/terraform) to your VM.

Modify the files as necessary to create a GCP Bucket and Big Query Dataset.
export GOOGLE_APPLICATION_CREDENTIALS="/home/michal/.gcloud/tokens/magnetic-energy-375219-c1c78ad83f33.json"
gcloud auth application-default login


## Question 1. Creating Resources

After updating the main.tf and variable.tf files run:

```
terraform apply
```
A1)

After running terraform apply: 
```
Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
...
Terraform will perform the following actions:

  # google_bigquery_dataset.dataset will be created
  + resource "google_bigquery_dataset" "dataset" {
...

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.dataset: Creating...
google_storage_bucket.data-lake-bucket: Creating...
google_storage_bucket.data-lake-bucket: Creation complete after 1s [id=dtc_data_lake_magnetic-energy-375219]
google_bigquery_dataset.dataset: Creation complete after 2s [id=projects/magnetic-energy-375219/datasets/trips_data_all]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

Paste the output of this command into the homework submission form.


## Submitting the solutions

* Form for submitting: [form](https://forms.gle/S57Xs3HL9nB3YTzj9)
* You can submit your homework multiple times. In this case, only the last submission will be used. 

Deadline: 26 January (Thursday), 22:00 CET

