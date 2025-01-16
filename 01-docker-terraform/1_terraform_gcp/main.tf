terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  credentials = file(var.project_config.credentials)
  project     = var.project_config.project_name
  region      = var.project_config.location
}

resource "google_storage_bucket" "demo-ckh-bucket" {
  name          = var.project_config.gcs_bucket_name 
  location      = var.project_config.location
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

resource "google_bigquery_dataset" "demo_ckh_dataset" {
  dataset_id =  var.project_config.bq_dataset_name
}