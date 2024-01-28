variable "credentials" {
  description = "My Credentials"
  default     = "/home/kashif/.gc/ny-rides.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
}


variable "project" {
  description = "Project"
  default     = "polished-will-411520"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "europe-north1-a"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "europe-north1"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default     = "terraform-demo-terra-bucket-kashif"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}