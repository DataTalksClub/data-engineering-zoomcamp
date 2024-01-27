variable "credentials" {
  description = "credentials"
  default     = "./keys/creds.json"
}

variable "project" {
  description = "Project"
  default     = "de-zc-411321"
}
variable "region" {
  description = "Project Region"
  default     = "us-central1"
}
variable "location" {
  description = "Project Location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My Big Query Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "storage bucket name"
  default     = "de-zc-411321-terra-bucket"
}

variable "gcs_storage_class" {
  description = "bucket storage class"
  default     = "STANDARD"
}
