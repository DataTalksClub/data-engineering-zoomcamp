# Week 1 Homework

## Create EC2 Instance
At first, create an EC2 instance with the following configuration (You have multiple options, this is for demonstration purpose):

* AMI: "Amazon Linux 2 AMI" (free-tier eligible)
* Instance Type: t2.micro
* Security Group: Create a new security group
* Security Group Rule: SSH
* Protocol: TCP
* Port Range: 22
* Source: Select "My IP" to allow only your current IP address or "Anywhere" to allow any IP address. Note that allowing "Anywhere" is less secure.
* Key Pair: Create a new key pair

In this case, my instance name is: `test_terraform_installation`, id is 
`i-03f4d3675005133f5`. I set Anywhere for the security group rule.

## Connect to EC2 Instance via SSH
After getting the `.pem` key file, I perform actions on WSL as follows:

```bash
mv /mnt/c/path/to/your/keypair.pem ~/
```
```bash
chmod 400 ~/keypair.pem
```

```bash
ssh -i /path/to/your/keypair.pem ec2-user@<Public-IP-Address-or-Public-DNS>
```
in my case:
```bash
ssh -i /home/gluonhiggs/test_terraform_installation.pem  ec2-user@ec2-54-226-58-86.compute-1.amazonaws.com
```

You should now be connected to your EC2 instance via SSH.

## Install Terraform
Update the package repository and install the required tools:

```bash
sudo yum update -y
sudo yum install -y unzip wget
```

Download the latest version of Terraform:

```bash
wget https://releases.hashicorp.com/terraform/1.1.5/terraform_1.1.5_linux_amd64.zip
```

Unzip the downloaded file and move the Terraform binary to a directory in your PATH:
```bash
unzip terraform_1.1.5_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```
### Verify the Terraform Installation
Verify that Terraform is installed correctly:
```bash
terraform -v
```
Create a new directory for your Terraform configuration files and navigate to it:

```bash
mkdir terraform-example
cd terraform-example
```
### Initialize Terraform
Create a new file named `main.tf` and open it with your preferred text editor 
```bash
nano main.tf
```
Add the following content to the `main.tf` file:
```hcl
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
  bucket = "${var.backend_bucket}_${var.project}"
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

```
Save the `main.tf` then modify the `variables.tf` as follows:
```hcl
variable "backend_bucket" {
  description = "The S3 bucket used to store the Terraform state file."
  default     = "terraform_data_lake"
}

variable "backend_key" {
  description = "The key used to store the Terraform state file in the S3 bucket."
  default     = "path/to/my/key"
}

variable "backend_region" {
  description = "The AWS region where the S3 bucket for the Terraform state file is located."
  default     = "us-east-1"
}

variable "project" {
  description = "Your AWS Account ID"
  default = "666243375423"
}

variable "region" {
  description = "Region for AWS resources."
  default = "us-east-1"
  type = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the Amazon Redshift cluster."
  type = list(string)
  default = ["subnet-098671ae252c7200a"]
}

variable "redshift_cluster_identifier" {
  description = "Amazon Redshift cluster identifier"
  type = string
  default = "trips-data-all"
}

variable "redshift_database_name" {
  description = "Database name for Amazon Redshift"
  type = string
  default = "trips_data_all"
}

variable "redshift_master_username" {
  description = "Master username for Amazon Redshift"
  type = string
  default = "test_terraform_redshift_admin"
}

variable "redshift_master_password" {
  description = "Master password for Amazon Redshift"
  type = string
  default = "April27th2023"
}

variable "redshift_node_type" {
  description = "Node type for Amazon Redshift"
  type = string
  default = "dc2.large"
}

variable "redshift_number_of_nodes" {
  description = "Number of nodes for Amazon Redshift"
  type = number
  default = 1
}

variable "redshift_security_group_id" {
  description = "Security group ID for Amazon Redshift"
  type = string
  default = "sg-0b0e1c5b1f1b0b1f9"
}

variable "redshift_ingress_cidr" {
  description = "CIDR block to allow ingress to the Amazon Redshift cluster"
  type = string
  default = "0.0.0.0/0"
}

```
Save and close the file. Then, initialize Terraform:
```bash
terraform init
```
Then, run `terraform plan` to see what Terraform will do:
```bash
terraform plan
```

If you want to allow access only from your current IP address, you can find your public IP address by searching "what is my IP" on Google or visiting a website like https://www.whatismyip.com/. After obtaining your IP address, you can create a CIDR block by appending `/32` to it. For example, if your IP address is `1.2.3.4`, the CIDR block would be `1.2.3.4/32`. This will allow only your current IP address to access the Redshift cluster.

If you want to allow access from a specific range of IP addresses, you need to define a CIDR block that covers the desired IP range. For example, if you want to allow access from the IP range `1.2.3.0 to 1.2.3.255`, the CIDR block would be `1.2.3.0/24`.

If you want to allow access from any IP address (not recommended for security reasons), you can use the CIDR block 0.0.0.0/0.

Everything looks good, so let's apply the changes:
```bash
terraform apply
```
You will be prompted to enter `yes` to confirm that you want to apply the changes. Enter `yes` and press Enter.








