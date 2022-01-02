locals {
  data_lake_bucket = "dtc_data_lake"
}

variable "project" {
  description = "The name of the GCP project"
  default = "<your-project-id>"
}

variable "region" {
  description = "Region for GCP resources"
  default = "europe-west6"
  type = string
}

variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket. Must be globally unique."
  default = ""
}

variable "storage_class" {
  default = "STANDARD"
}
