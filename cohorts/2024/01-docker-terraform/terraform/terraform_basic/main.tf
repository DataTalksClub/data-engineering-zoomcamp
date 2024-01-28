terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  # Credentials only needs to be set if you do not have the GOOGLE_APPLICATION_CREDENTIALS set
  credentials = "/Users/harryy/credentials/gcp-datatalk-de-terraform-runner.json"
  project     = "datatalk-de"
  region      = "us-west1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name     = "datatalk-de-c1-1"
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

resource "google_bigquery_dataset" "datatalk_de_c1" {
  dataset_id = "demo1_dataset"
  project    = "datatalk-de"
  location   = "US"
}