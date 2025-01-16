# variable "location" {
#   description = "Project location"
#   type        = string
#   default     = "us-central1"

# }

# variable "credentials" {
#   description = "Path to the service account key file"
#   type        = string
#   default     = "./terraform/keys/datazoomcampprogram-98a99ba69792.json"
  
# }

# variable "project-name" {
#   description = "Project Name"
#   type        = string
#   default     = "datazoomcampprogram"

# }

# variable "bq_dataset_name" {
#   description = "My BigQuery dataset name"
#   type        = string
#   default     = "demo_ckh_dataset"

# }

# variable "gcs_bucket_name" {
#   description = "My GCS bucket name"
#   type        = string
#   default     = "demo-ckh-bucket"

# }

# variable "gcs_storage_class" {
#   description = "Bucket Storage Class"
#   type        = string
#   default     = "STANDARD"

# }


variable "project_config" {
  description = "Configuration for the project"
  type = object({
    location           = string
    project_name       = string
    bq_dataset_name    = string
    gcs_bucket_name    = string
    gcs_storage_class  = string
    credentials        = string
  })
  default = {
    location           = "us-central1"
    project_name       = "datazoomcampprogram"
    bq_dataset_name    = "demo_ckh_dataset"
    gcs_bucket_name    = "demo-ckh-bucket"
    gcs_storage_class  = "STANDARD"
    credentials        = "./terraform/keys/datazoomcampprogram-98a99ba69792.json"
  }
}
