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
  credentials = "E:/HCL_Technical_Lead/SIE_OSIV_HCL_TRAINING/PYTHON_DS_DE/Pgadmin_datatalks_sql_DATAPIPELINE/01-docker-terraform/1_terraform_gcp/terraform/keys/mycred.json"
  project = "linen-airway-420415"
  region  = "us-central1"
}



resource "google_storage_bucket" "data-lake-bucket" {
  name          = "terraform-demo-s100rab-16022024"
  location      = "US"


  # Optional, but recommended settings:
  storage_class = "STANDARD"
  uniform_bucket_level_access = true

  versioning {
    enabled     = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 3  // days
    }
  }

  force_destroy = true
}


# resource "google_bigquery_dataset" "dataset" {
#   dataset_id = "<The Dataset Name You Want to Use>"
#   project    = "<Your Project ID>"
#   location   = "US"
# }