variable "credentials" {
  description = "My Credentials"
  default     = "C:/Users/NguyenThanh/Documents/CODE/DataEngineeringZoomcamp/graphical-fort-463908-u4-8978625e1df6.json"
}

variable "project" {
  description = "Project"
  default     = "graphical-fort-463908-u4"
}

variable "region" {
  description = "Region"
  default     = "asia-southeast1"
}

variable "location" {
  description = "Project Location"
  default     = "asia-southeast1"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "dtc_de_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "dtc_de_bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}