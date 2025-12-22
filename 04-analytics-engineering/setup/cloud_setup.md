# Cloud Setup Guide

This guide walks you through setting up dbt to work with the BigQuery data warehouse you created in Module 3.

<div align="center">

[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)
[![Looker Studio](https://img.shields.io/badge/Looker_Studio-4285F4?style=for-the-badge&logo=looker&logoColor=white)](https://lookerstudio.google.com/)

</div>

> [!NOTE]
> This guide assumes you've completed [Module 3: Data Warehouse](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/03-data-warehouse) where you:
> - Created a GCP project and enabled the BigQuery API
> - Created a service account with BigQuery permissions
> - Loaded NYC taxi data into BigQuery (in the `nytaxi` dataset)
>
> If you haven't completed Module 3, please go back and complete it first.

## Step 1: Verify Your BigQuery Setup

Before setting up dbt Cloud, confirm you have the required data and credentials from Module 3.

### Check Your Service Account

You should already have a service account JSON key file from Module 3. Make sure it has these permissions:

- **BigQuery Data Editor**
- **BigQuery Job User**
- **BigQuery User**

If you need to create a new service account or download a new key, refer back to [Module 3's setup instructions](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/03-data-warehouse).

### Verify Your Data from Module 3

1. Go to [BigQuery Console](https://console.cloud.google.com/bigquery)
2. In the Explorer panel on the left, expand your project
3. You should see the `nytaxi` dataset from Module 3
4. Expand the `nytaxi` dataset - you should see tables like:
   - `yellow_tripdata` or `yellow_tripdata_partitioned`
   - `green_tripdata` or `green_tripdata_partitioned` (if you completed the homework)

### Note Your Dataset Location

When you created your BigQuery datasets in Module 3, you chose a location (e.g., `US`, `EU`, `us-central1`). You'll need to use the same location when configuring dbt.

**To check your dataset location:**
1. In BigQuery Console, click on the `nytaxi` dataset
2. Look for **Data location** in the dataset details

## Step 2: Sign Up for dbt Platform

dbt Platform is dbt's cloud-based development environment with a web IDE, scheduler, and collaboration features. dbt offers a **free Developer plan**. This should be more than enough to learn dbt and follow the course.

## Step 3: Create a New dbt Project

Now you'll create a fresh dbt project from scratch in dbt Cloud.

1. Click **Create a Project**

2. Enter a project name:
   - Project name: `taxi_rides_ny`

3. Click **Continue**

## Step 4: Configure BigQuery Connection

Connect dbt Cloud to your BigQuery data warehouse.

### Upload Service Account JSON

1. For the connection type, select **BigQuery**

2. Click **Upload a Service Account JSON file**

3. Select the service account JSON key file from Module 3

4. dbt will automatically extract:
   - Your GCP project ID
   - Authentication credentials

### Configure Connection Settings

1. **Dataset**: Enter `dbt_prod`
   - This is the base schema name where dbt will create datasets
   - dbt will organize your models into schemas like:
     - `dbt_prod_staging` - for staging models
     - `dbt_prod_intermediate` - for intermediate models
     - `dbt_prod_marts` - for final analytics tables

2. **Location**: Select the same location as your `nytaxi` dataset from Module 3
   - Example: `US`, `EU`, or `us-central1`
   - **This must match your nytaxi dataset location**

3. **Timeout**: `300` seconds

4. **Maximum Bytes Billed**: (optional)
   - Leave blank for unlimited, OR
   - Set a limit like `1000000000` (1 GB) to prevent runaway queries

### Test the Connection

1. Click **Test Connection**

2. You should see a success message: ✅ "Connection test succeeded"

3. Click **Continue**

## Step 5: Set Up Your Repository

dbt Cloud needs a Git repository to store your project code. You have two options:

- Let dbt Manage the Repository (Recommended for Beginners)
- Connect Your Own GitHub Repository (Recommended for Production)

It doesn't matter which one you prefer for this course.

## Step 6: Initialize Your Development Environment

1. dbt Cloud will now set up your development environment

2. This process takes about 1-2 minutes

3. Once complete, you'll see: **"Successfully set up development environment"**

4. Click **Start developing in the IDE**

You'll be taken to the dbt Cloud IDE with a fresh, empty project!

## Additional Resources

* [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
* [dbt Documentation](https://docs.getdbt.com/docs/cloud/about-cloud/dbt-cloud-features)
* [Looker Studio Help Center](https://support.google.com/looker-studio)
* [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices)
* [NYC Taxi Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)
