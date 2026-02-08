# Cloud Setup Guide

This guide walks you through setting up dbt to work with the BigQuery data warehouse you created in Module 3.

<div align="center">

[![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)](https://www.getdbt.com/)
[![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://cloud.google.com/bigquery)

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

If you need to create a new service account or download a new key, follow the instructions below.

### How to Download Service Account JSON Key

If you don't have the JSON key file or need to download a new one:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)

2. Navigate to **IAM & Admin** > **Service Accounts**
   - Or use the search bar and type "Service Accounts"

3. Find your service account in the list
   - It should look like: `service-account-name@project-id.iam.gserviceaccount.com`
   - If you don't have a service account yet, click **+ CREATE SERVICE ACCOUNT** and:
     - Enter a name (e.g., `dbt-bigquery-service-account`)
     - Click **CREATE AND CONTINUE**
     - Add these roles:
       - **BigQuery Admin** (or at minimum: BigQuery Data Editor, BigQuery Job User, BigQuery User)
     - Click **CONTINUE** > **DONE**

4. Click on your service account name to open its details

5. Go to the **KEYS** tab

6. Click **ADD KEY** > **Create new key**

7. Select **JSON** as the key type

8. Click **CREATE**

9. The JSON key file will automatically download to your computer
   - Save it in a secure location
   - **Never commit this file to Git or share it publicly** - it contains credentials to access your GCP resources

The downloaded JSON file will look something like this:

```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "...",
  "private_key": "-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n",
  "client_email": "service-account-name@project-id.iam.gserviceaccount.com",
  ...
}
```

You'll use this JSON file in Step 4 to connect dbt Cloud to BigQuery.

### Load the Taxi Data

This module uses **yellow and green taxi data for 2019-2020**, which is different from the data you loaded in Module 3. Using the same approach you learned in Module 3, load the following data into your BigQuery `nytaxi` dataset:

- **Yellow taxi trip records** for all months of 2019 and 2020
- **Green taxi trip records** for all months of 2019 and 2020

Parquet files are available from the [NYC TLC trip data page](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page).

After loading, verify your data:

1. Go to [BigQuery Console](https://console.cloud.google.com/bigquery)
2. In the Explorer panel on the left, expand your project
3. You should see the `nytaxi` dataset
4. Expand the `nytaxi` dataset - you should see tables:
   - `green_tripdata`
   - `yellow_tripdata`

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

## Step 6: Create Your Development Environment

### What Are Environments in dbt?

In dbt, **environments** define different contexts where your data transformations run:

- **Development Environment**: Your personal workspace for building and testing models
  - Uses your personal credentials
  - Creates temporary schemas with your name (e.g., `dbt_<your_name>`)
  - Changes only affect your work, not production
  - Used when working in the dbt Cloud IDE

- **Deployment Environment**: The production workspace where final models run on schedule
  - Uses service account credentials
  - Creates production schemas (e.g., `dbt_prod_staging`, `dbt_prod_marts`)
  - Used by scheduled jobs that keep your data warehouse updated

Think of it like having a draft folder (development) and a published folder (deployment) for your analytics code.

### Create Your Development Environment

After setting up your repository, dbt Cloud will prompt you to initialize a development environment.

1. You'll see a screen titled **"Initialize your development environment"**

2. **Development Credentials**: Choose how dbt will connect to BigQuery when you develop
   - **Option 1 - OAuth** (Recommended):
     - Click **Authorize dbt Cloud**
     - Sign in with your Google account
     - Grant BigQuery permissions
     - dbt will use your personal Google credentials

   - **Option 2 - Service Account**:
     - Use the same service account JSON from Step 4
     - Less secure for development (shared credentials)

3. **Development Schema**: This is where your personal development models will be created
   - dbt automatically suggests: `dbt_<your_name>` (e.g., `dbt_john_smith`)
   - You can customize it, but the default is recommended
   - This schema is separate from production (`dbt_prod`)

4. **Target Name**: Leave as `dev` (default)
   - This is just an internal identifier for this environment

5. Click **Test Connection** to verify your credentials work

6. Click **Continue**

## Step 7: Initialize the Environment

1. dbt Cloud will now set up your development environment
   - Installing dbt dependencies
   - Connecting to your repository
   - Preparing the IDE workspace

2. This process takes about 1-2 minutes

3. Once complete, you'll see: **"Successfully set up development environment"**

4. Click **Start developing in the IDE**

You'll be taken to the dbt Cloud IDE with a fresh project ready for development!

## Additional Resources

* [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
* [dbt Documentation](https://docs.getdbt.com/docs/cloud/about-cloud/dbt-cloud-features)
* [BigQuery Best Practices](https://cloud.google.com/bigquery/docs/best-practices)
* [NYC Taxi Data Dictionary](https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf)
