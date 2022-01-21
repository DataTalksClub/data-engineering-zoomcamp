resource "google_project_service" "storagetransfer" {
  project = var.project
  service = "storagetransfer.googleapis.com"
}

data "google_storage_transfer_project_service_account" "default" {
  project = var.project
}

resource "google_storage_bucket" "transfer-service-terraform" {
  name          = "transfer-service-terraform"
  storage_class = "STANDARD"
  project       = var.project
  location      = "EU"
}

resource "google_storage_bucket_iam_member" "transfer-service-terraform-iam" {
  bucket     = google_storage_bucket.transfer-service-terraform.name
  role       = "roles/storage.admin"
  member     = "serviceAccount:${data.google_storage_transfer_project_service_account.default.email}"
  depends_on = [google_storage_bucket.transfer-service-terraform]
}

resource "google_storage_transfer_job" "s3-bucket-nightly-backup2" {
  description = "Test run 2"
  project     = var.project

  transfer_spec {
    transfer_options {
      delete_objects_unique_in_sink = false
    }
    aws_s3_data_source {
      bucket_name = "nyc-tlc"
      aws_access_key {
        access_key_id     = var.access_key_id
        secret_access_key = var.aws_secret_key
      }
    }
    gcs_data_sink {
      bucket_name = google_storage_bucket.transfer-service-terraform.name
      path = ""
    }
  }

  schedule {
    schedule_start_date {
      year  = 2022
      month = 01
      day   = 21
    }
    schedule_end_date {
      year  = 2022
      month = 01
      day   = 21
    }
  }

  depends_on = [google_storage_bucket_iam_member.transfer-service-terraform-iam]
}