# Specifies the geographic location for AWS resource deployment.
# Defaulting to Stockholm (eu-north-1) to keep latency low for European users.
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type = string
  default = "eu-north-1"

}

# The unique identifier for the S3 bucket where raw data will be stored.
# S3 bucket names must be globally unique across all AWS accounts.
variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "data-engineering-zoomcamp-1568692036"
}

# Defines the logical grouping for metadata in the AWS Glue Catalog.
# This allows tools like Athena to query the S3 data using SQL.
variable "dataset_name" {
  description = "Glue Catalog database name (logical dataset for Athena/Glue)"
  type        = string
  default = "ny_taxi_database"
}
