# variable "credentials" {
#   description = "My Credentials"
#   default     = "./keys/my-creds.json"
  #ex: if you have a directory where this file is called keys with your service account json file
  #saved there as my-creds.json you could use default = "./keys/my-creds.json"
# }


variable "project" {
  description = "Project"
  default     = "tidy-daylight-411205"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region, europe-north1
  default = "asia-southeast1"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default = "US"
}

variable "bq_dataset_name" {
  description = "Homework-01 Dataset Name"
  #Update the below to what you want your dataset to be called
  default = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "Homework-01 Bucket Name"
  #Update the below to a unique bucket name
  default = "tidy-daylight-411205-hmwk01-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}
