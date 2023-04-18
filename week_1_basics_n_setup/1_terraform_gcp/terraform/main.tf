terraform {
  required_version = ">= 1.0"
  backend "s3" {
    bucket = "i-03f4d3675005133f5"
    key    = "path/to/my/key"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

# Data Lake Bucket
resource "aws_s3_bucket" "data-lake-bucket" {
  bucket = "${var.backend_bucket}-${var.project}"
  force_destroy = true
}

# Redshift
resource "aws_redshift_cluster" "dwh" {
  cluster_identifier = var.redshift_cluster_identifier
  database_name      = var.redshift_database_name
  master_username    = var.redshift_master_username
  master_password    = var.redshift_master_password
  node_type          = var.redshift_node_type
  number_of_nodes    = var.redshift_number_of_nodes
  vpc_security_group_ids = [aws_security_group.redshift_security_group.id]
  cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
}

resource "aws_redshift_subnet_group" "redshift_subnet_group" {
  name       = "redshift-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "redshift_security_group" {
  name = "redshift-security-group"
}

resource "aws_security_group_rule" "redshift_ingress" {
  security_group_id = aws_security_group.redshift_security_group.id

  type        = "ingress"
  from_port   = 5439
  to_port     = 5439
  protocol    = "tcp"
  cidr_blocks = [var.redshift_ingress_cidr]
}
