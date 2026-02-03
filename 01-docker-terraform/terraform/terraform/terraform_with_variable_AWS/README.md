# AWS Terraform Data Lake (GCP Equivalent)

## 📌 Overview

This repository contains an **AWS-based Terraform implementation** that mirrors the **Google Cloud Platform (GCP)** infrastructure used in the Data Engineering course (e.g. GCS + BigQuery), but implemented using **AWS services**.

The goal is to help learners who:
- Are enrolled in a **GCP-focused Data Engineering course**
- Prefer or need to work with **AWS**
- Want to understand **cloud-agnostic data engineering concepts**

This setup focuses on building a **basic data lake foundation** using:
- **Amazon S3** (equivalent to GCS)
- **AWS Glue Data Catalog** (equivalent to BigQuery datasets / metadata layer)
- **Terraform** as Infrastructure as Code (IaC)

---

## 🏗️ Architecture Mapping (GCP → AWS)

| GCP Service | AWS Equivalent | Purpose |
|------------|---------------|---------|
| Google Cloud Storage (GCS) | Amazon S3 | Data Lake storage |
| Uniform Bucket Level Access | S3 Public Access Block | Secure bucket access |
| Object Lifecycle Rules | S3 Lifecycle Configuration | Automatic data expiration |
| BigQuery Dataset | AWS Glue Catalog Database | Metadata & query layer |
| Terraform (GCP provider) | Terraform (AWS provider) | Infrastructure as Code |

---

## 📁 Project Structure

```text
.
├── main.tf            # Core infrastructure resources
├── variables.tf       # Input variable definitions
├── terraform.tfvars   # Environment-specific values
└── README.md          # Project documentation
