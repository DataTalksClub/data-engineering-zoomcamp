variable "aws_region" {
  description = "AWS region to deploy resources in"
  type = string
  default = "eu-north-1"

}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "data-engineering-zoomcamp-1568692036"
}


variable "dataset_name" {
  description = "Glue Catalog database name (logical dataset for Athena/Glue)"
  type        = string
  default = "ny_taxi_database"
}