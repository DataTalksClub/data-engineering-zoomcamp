variable "credentials" {
  description = "My Credentials"
  default     = "./keys/credentials.json"
}

variable "project" {
  description = "Project"
  default     = "static-sentinel-448914-i9"
}

variable "location" {
  description = "Project Location"
  default     = "europe-west1"
}

variable "region" {
  description = "Region"
  default     = "europe-west1"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "static-sentinel-448914-i9-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}