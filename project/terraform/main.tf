terraform {
  required_version = ">= 1.0"
  backend "local" {}  # Can change from "local" to "gcs" (if google) or "s3" (if aws), in case you would like to save your tf-state online
  required_providers {
    google = {
      source  = "hashicorp/google"
    }
  }
}

# Configure the Google Cloud provider
provider "google" {
  project = var.project
  region = var.region
  // credentials = file(var.credentials)  # Use this if you do not want to set env-var GOOGLE_APPLICATION_CREDENTIALS
}

# Create a Google Cloud Storage Bucket
resource "google_storage_bucket" "data-lake-bucket" {
  name          = "${local.data_lake_bucket}_${var.project}" # Concatenating DL bucket & Project name for unique naming
  location      = var.region

  # Optional, but recommended settings:
  storage_class = var.storage_class
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30  // days
    }
  }

  force_destroy = true
}
