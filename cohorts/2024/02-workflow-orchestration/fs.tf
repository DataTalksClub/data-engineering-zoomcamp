# fs.tf | File System Configuration

resource "google_filestore_instance" "instance" {
  name = "${var.app_name}"
  location = var.zone
  tier = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}

resource "google_vpc_access_connector" "connector" {
  name          = "${var.app_name}-connector"
  ip_cidr_range = "10.8.0.0/28"
  region        = var.region
  network       = "default"
}

# ---------------------------------------------------
# Use a cheaper NFS provisioned on GCP Compute Engine.
# 1. Uncomment the module "nfs" below
# 2. Update the environment variable in google_cloud_run_service.run_service.
#    Set "FILESTORE_IP_ADDRESS" to module.nfs.internal_ip and
#    "FILE_SHARE_NAME" to "share/mage".
# 3. Comment out the google_filestore_instance.instance resource.
# ---------------------------------------------------

# module "nfs" {
#   source  = "DeimosCloud/nfs/google"
#   version = "1.0.1"
#   # insert the 5 required variables here
#   name_prefix = "${var.app_name}-nfs"
#   # labels      = local.common_labels
#   # subnetwork  = module.vpc.public_subnetwork
#   attach_public_ip = true
#   project       = var.project_id
#   network       = "default"
#   machine_type  = "e2-small"
#   source_image_project  = "debian-cloud"
#   image_family  = "debian-11-bullseye-v20230629"
#   export_paths  = [
#     "/share/mage",
#   ]
#   capacity_gb = "50"
# }
