terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.13.0"
    }
  }
}

provider "google" {
  project = "linen-walker-412417"
  region  = "us-central1"
}

resource "google_storage_bucket" "demo-bucket" {
  name     = "terraform-demo-412417-terra-bucket"
  location = "US"

  # Optional, but recommended settings:
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 30 // days
    }
  }

  force_destroy = true
}


resource "google_bigquery_dataset" "demo-dataset" {
  dataset_id = "demo_dataset"
  project    = "linen-walker-412417"
  location   = "US"
}
