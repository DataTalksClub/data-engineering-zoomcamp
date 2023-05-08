variable "backend_bucket" {
  description = "The S3 bucket used to store the Terraform state file."
  default     = "terraform-data-lake"
}

variable "backend_key" {
  description = "The key used to store the Terraform state file in the S3 bucket."
  default     = "path/to/my/key"
}

variable "backend_region" {
  description = "The AWS region where the S3 bucket for the Terraform state file is located."
  default     = "us-east-1"
}

variable "project" {
  description = "Your AWS Account ID"
  default = "666243375423"
}

variable "region" {
  description = "Region for AWS resources."
  default = "us-east-1"
  type = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the Amazon Redshift cluster."
  type = list(string)
  default = ["subnet-098671ae252c7200a"]
}

variable "redshift_cluster_identifier" {
  description = "Amazon Redshift cluster identifier"
  type = string
  default = "trips-data-all"
}

variable "redshift_database_name" {
  description = "Database name for Amazon Redshift"
  type = string
  default = "trips_data_all"
}

variable "redshift_master_username" {
  description = "Master username for Amazon Redshift"
  type = string
  default = "test_terraform_redshift_admin"
}

variable "redshift_master_password" {
  description = "Master password for Amazon Redshift"
  type = string
  default = "April27th2023"
}

variable "redshift_node_type" {
  description = "Node type for Amazon Redshift"
  type = string
  default = "dc2.large"
}

variable "redshift_number_of_nodes" {
  description = "Number of nodes for Amazon Redshift"
  type = number
  default = 1
}

variable "redshift_security_group_id" {
  description = "Security group ID for Amazon Redshift"
  type = string
  default = "sg-0b0e1c5b1f1b0b1f9"
}

variable "redshift_ingress_cidr" {
  description = "CIDR block to allow ingress to the Amazon Redshift cluster"
  type = string
  default = "0.0.0.0/0"
}