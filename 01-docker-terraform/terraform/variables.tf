variable "project_name" {
  description = "project name"
  default     = "zoomcamp-473216-terra-bucket"
}

variable "location" {
  description = "project location"
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "zoomcamp-473216-terra-bucket"
  default     = "STANDARD"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
