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

## Step 1: Verify Your Service Account

You should already have a service account from Module 3. If you need to create a new service account key for dbt (or lost your previous one), refer back to [Module 3's setup instructions](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/03-data-warehouse) for creating service accounts and downloading JSON keys.

> [!TIP]
> If you already have a service account JSON key file with BigQuery permissions from Module 3, you can reuse it for dbt. Just make sure it has at least these permissions:
> - **BigQuery Data Editor**
> - **BigQuery Job User**
> - **BigQuery User**

## Step 2: Verify Your Data from Module 3

In Module 3, you loaded NYC taxi data into BigQuery. Let's verify that data exists and is accessible for dbt to transform.

### Check Your Existing Data

1. Go to [BigQuery Console](https://console.cloud.google.com/bigquery)
2. In the Explorer panel on the left, expand your project
3. You should see the `nytaxi` dataset from Module 3
4. Expand the `nytaxi` dataset - you should see tables like:
   - `yellow_tripdata_partitioned` (or `yellow_tripdata_non_partitioned`)
   - `external_yellow_tripdata`
   - Possibly `green_tripdata` tables if you completed the homework

### Verify Data is Accessible

Run a quick query to confirm you can access the data:

```sql
-- Check row counts (replace PROJECT_ID with your actual project ID)
SELECT COUNT(*) as row_count
FROM `PROJECT_ID.nytaxi.yellow_tripdata_partitioned`;

-- Preview the data
SELECT *
FROM `PROJECT_ID.nytaxi.yellow_tripdata_partitioned`
LIMIT 10;
```

> [!IMPORTANT]
> **Note your dataset location**: When you created your BigQuery datasets in Module 3, you chose a location (e.g., `US`, `EU`, `us-central1`). You'll need to use the same location when configuring dbt. To check your dataset location:
> 1. In BigQuery Console, click on the `nytaxi` dataset
> 2. Look for **Data location** in the dataset details

## Step 3: Understanding dbt's Data Architecture

Before setting up dbt, it's important to understand how dbt organizes data:

- **Source data** (`nytaxi` dataset): Your existing raw data from Module 3
- **Staging models** (created by dbt): Cleaned, standardized versions of source data
- **Intermediate models** (created by dbt): Major transformations not meant for business users
- **Marts** (created by dbt): Business-ready datasets for analytics and reporting

This **sources → staging → intermediate → marts** pattern is the industry-standard approach in modern analytics engineering. dbt will automatically create the necessary datasets when you run your transformations.

## Step 4: Set Up dbt

dbt is dbt's cloud-based development environment. It combines the power of dbt with a web-based IDE, making it easier to build and manage your data transformations.

### Sign Up for dbt

1. Go to [dbt](https://www.getdbt.com/signup)
2. Sign up with your email or GitHub account
3. Verify your email address
4. You'll be taken to the dbt dashboard

### Create a New dbt Project

1. Click **Create a Project**
2. Enter a project name (e.g., `taxi_rides_ny`)
3. For the connection, select **BigQuery**

### Configure BigQuery Connection

Now you'll connect dbt to your BigQuery project:

1. **Upload Service Account JSON**:
   - Click **Upload a Service Account JSON file**
   - Select the service account JSON key file from Module 3
   - dbt will automatically extract your project ID and credentials

2. **Configure Connection Settings**:
   - **Dataset**: `dbt_production` (this will be the default dataset for dbt-created models)
   - **Location**: Must match the location you used in Module 3 (check your `nytaxi` dataset location - typically `US`)
   - **Timeout**: `300` seconds
   - **Maximum Bytes Billed**: Leave blank for unlimited (or set a limit like `1000000000` for 1 GB to prevent runaway queries)

3. **Test Connection**:
   - Click **Test Connection**
   - You should see a success message confirming dbt can connect to BigQuery

4. Click **Continue**

> [!IMPORTANT]
> The **Dataset** setting (`dbt_production`) is where dbt will create your staging, intermediate, and mart models. This is separate from your `nytaxi` dataset which contains your source data from Module 3.

### Configure Repository

dbt can connect to a Git repository to store your dbt project code:

1. **Option A: Managed Repository** (Recommended for learning)
   - Select **Let dbt manage my repository**
   - dbt will create and host a Git repository for you
   - This is the easiest option and perfect for getting started

2. **Option B: Connect Git Repository** (For production projects)
   - Select **Connect to GitHub/GitLab/Azure DevOps**
   - Follow the prompts to authorize and select a repository
   - This gives you full control over version control

Select your preferred option and click **Continue**.

### Initialize Development Environment

1. dbt will create your development environment (this takes ~1-2 minutes)
2. Once complete, you'll be taken to the dbt IDE
3. You'll see the default project structure with example models

### Configure Source Data

Now you need to tell dbt where your source data from Module 3 lives:

1. In the dbt IDE, navigate to **models/staging/**
2. Create or edit `schema.yml` and add:

```yaml
version: 2

sources:
  - name: nytaxi
    database: YOUR_PROJECT_ID  # Replace with your GCP project ID
    schema: nytaxi
    tables:
      - name: yellow_tripdata_partitioned
        description: "Yellow taxi trip records from Module 3"
```

> [!IMPORTANT]
> Replace `YOUR_PROJECT_ID` with your actual GCP project ID (e.g., `taxi-rides-ny`). This tells dbt where to find the data tables you created in Module 3.
>
> **Note**: We're using `yellow_tripdata_partitioned` as the source table since that's the optimized table you created in Module 3. If you created green taxi tables or used different names, adjust accordingly.

### Test the Setup

Let's verify everything works:

1. In the dbt IDE, click the **Command Line** button at the bottom
2. Run:

   ```bash
   dbt debug
   ```

3. You should see all checks pass with green checkmarks ✓

If you see errors, verify:

- Service account JSON file was uploaded correctly
- BigQuery API is enabled in your GCP project (it should be from Module 3)
- Dataset location matches between your `nytaxi` dataset and dbt configuration
- Your `sources` configuration in `schema.yml` uses the correct project ID and dataset name (`nytaxi`)

## Additional Resources

* [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
* [dbt Documentation](https://docs.getdbt.com/docs/cloud/about-cloud/dbt-cloud-features)
* [Looker Studio Help Center](https://support.google.com/looker-studio)
* [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices)
* [NYC Taxi Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)
