variable "credentials" {
  description = "Service account credentials"
  default = "./keys/terraform-runner.json"
}

variable "project" {
  description = "Project"
  default = "dtc-de-course-449416"
}
variable "region" {
  description = "Region"
  default = "us-central1"
}
variable "location" {
  description = "Project location"
  default = "US"
}
variable "bq_dataset_name" {
  description = "My BigQuery dataset name"
  default = "demo_dataset"
}
variable "gcs_bucket_name" {
  description = "My GCS bucket name"
  default = "dtc-de-course-449416-terra-bucket"
  
}
variable "gcs_storage_class" {
  description = "Bucket storage class"
  default = "STANDARD"
}