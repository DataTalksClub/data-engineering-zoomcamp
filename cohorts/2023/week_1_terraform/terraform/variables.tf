locals {
  data_lake_bucket = "dtc_data_lake"
  bucket_name_value = var.bucket_name != "" ? var.bucket_name : local.data_lake_bucket
  final_bucket_name_value= "${local.bucket_name_value}_${var.project}"
}

variable "project" {
  description = "Your GCP Project ID"
  default = "magnetic-energy-375219"
  type = string
}

variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default = "europe-west6"
  type = string
}

# no need for this for now
variable "bucket_name" {
  description = "The name of the Google Cloud Storage bucket. Must be globally unique."
  default = ""
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

variable "TABLE_NAME" {
  description = "BigQuery Table"
  type = string
  default = "ny_trips"
}
