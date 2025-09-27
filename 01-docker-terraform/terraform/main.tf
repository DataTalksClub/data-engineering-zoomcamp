terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.4.0"
    }
  }
}

provider "google" {
  # Configuration options
  project = var.gcs_bucket_name
  region  = "us-central1"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = var.bq_dataset_name
  location      = var.location
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}


resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = "demo_dataset"
}
