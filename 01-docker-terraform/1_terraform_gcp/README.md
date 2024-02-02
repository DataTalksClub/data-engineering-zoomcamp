## Local Setup for Terraform and GCP

### Pre-Requisites
1. Terraform client installation: https://www.terraform.io/downloads
2. Cloud Provider account: https://console.cloud.google.com/ 


### Terraform Concepts
[Terraform Overview](1_terraform_overview.md)

### 2024 (local) GCP setup

1. [Setup for First-time](2_gcp_overview.md#initial-setup)
    * [Only for Windows](windows.md) - Steps 4 & 5
2. [IAM / Access specific to this course](2_gcp_overview.md#setup-for-access)


### Terraform Workshop for GCP Infra
Your setup is ready!
Now head to the [terraform](terraform) directory, and perform the execution steps to create your infrastructure.


### 2024 GCP VM setup

- setup SSH keys (must be on host, ie Windows), add SSH key to whole GCP or per VM on GCP
- if per VM, create VM with the project active. So the VM is already tied to this `nyc-taxi-ella` project
- edit/create config file with external IP (must be on host, ie Windows)
- https://youtu.be/ae-CV2KfoN0?si=o7NMs70d7YmdY6D_
- [install docker engine](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository). 
  - Docker engine has docker.io and docker-compose built-in, so all the chmod stuff and manually installing in /.local/bin and export PATH is obsolete
- be sure to also perform [Linux post-installation steps for Docker Engine](https://docs.docker.com/engine/install/linux-postinstall/)
- clone DTC DE repo; use http as we're already using SSH to access this VM from Windows Host. 
