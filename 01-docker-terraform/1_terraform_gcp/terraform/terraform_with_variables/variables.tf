variable "credentials" {
  description = "My Credentials"
  default     = "E:/HCL_Technical_Lead/SIE_OSIV_HCL_TRAINING/PYTHON_DS_DE/Pgadmin_datatalks_sql_DATAPIPELINE/01-docker-terraform/1_terraform_gcp/terraform/keys/mycred.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}


variable "project" {
  description = "My Demo Project - terraform Datatalks"
  default     = "linen-airway-420415"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default = "us-central1"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default = "terraform_bq_dataset_s100rab_16042024"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default = "terraform_gcs_dataset_s100rab_16042024"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}