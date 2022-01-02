locals {
  data_lake_bucket = "dtc_data_lake"
}

variable "project" {
  description = "The name of the GCP project"
  default = "pivotal-surfer-336713"
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
