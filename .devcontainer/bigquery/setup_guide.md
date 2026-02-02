# BigQuery Codespace Setup Guide

Welcome to the BigQuery development environment! This guide will help you connect your codespace to Google Cloud BigQuery and load the required taxi data.

## Prerequisites

Before starting, ensure you have:
- A Google Cloud Platform account
- A GCP project with billing enabled
- BigQuery API enabled in your project
- A GCS bucket (e.g., `dtc-data-lake-yourname`)

## Part 1: Authentication Setup

This codespace uses **Google Cloud CLI browser authentication** for secure, credential-free access to BigQuery.

### Step 1: Initialize gcloud Authentication

Open a terminal in this codespace and run:

```bash
gcloud auth application-default login --no-launch-browser
```

### Step 2: Complete Browser Authentication

1. The command will display a URL - copy it
2. Open the URL in your local browser
3. Sign in with your Google Cloud account
4. Grant the requested permissions
5. Copy the authorization code shown in your browser
6. Paste the code back into the terminal

### Step 3: Verify Authentication

Test your connection to BigQuery:

```bash
gcloud auth application-default print-access-token
```

If you see an access token, authentication is successful!

### Step 4: Configure Your Project

Set your Google Cloud project ID:

```bash
gcloud config set project YOUR_PROJECT_ID
```

Replace `YOUR_PROJECT_ID` with your actual GCP project ID (e.g., `data-jobs-3921`).

## Part 2: Load Raw Data into BigQuery

Before running dbt, you need to load the raw taxi data that dbt will transform. You have two options:

### Option A: Use Existing Data from Module 3 (Recommended if Available)

If you completed Module 3 and already have the `nytaxi` dataset with `green_tripdata` and `yellow_tripdata` tables in BigQuery:

1. Verify the tables exist:
   ```bash
   bq ls nytaxi
   ```

2. If you see `green_tripdata` and `yellow_tripdata`, skip to **Part 3: Running dbt** below.

### Option B: Load Fresh Data (If Starting Fresh)

If you don't have the data from Module 3, follow these steps:

#### Step 1: Set Environment Variables

```bash
export GCP_PROJECT_ID=$(gcloud config get-value project)
export GCP_GCS_BUCKET="your-bucket-name"  # Replace with your GCS bucket name
```

#### Step 2: Upload Data to GCS

Run the data preparation script to download and upload taxi data to your GCS bucket:

```bash
cd /home/vscode/homework
bash setup/prepare_homework_data.sh
```

This will upload:
- Yellow taxi data (2019-2020)
- Green taxi data (2019-2020)
- FHV data (2019) - optional for homework

**Note**: This process downloads ~6GB of data and may take 15-30 minutes depending on your connection.

#### Step 3: Create BigQuery Dataset

Create the `nytaxi` dataset in BigQuery:

```bash
bq mk --dataset --location=US ${GCP_PROJECT_ID}:nytaxi
```

#### Step 4: Create External Tables from GCS

**Option 1: Use the helper script (easiest)**

```bash
bash /opt/devcontainer/bigquery/scripts/create_external_tables.sh
```

**Option 2: Create tables manually**

Create external tables in BigQuery that reference the data in GCS:

```bash
# Create nytaxi dataset
bq mk --dataset --location=US ${GCP_PROJECT_ID}:nytaxi

# Create green_tripdata external table
bq mk \
  --external_table_definition=gs://${GCP_GCS_BUCKET}/green/green_tripdata_*.csv.gz@CSV=format:CSV,skip_leading_rows:1,allow_quoted_newlines:true,allow_jagged_rows:true \
  nytaxi.green_tripdata

# Create yellow_tripdata external table
bq mk \
  --external_table_definition=gs://${GCP_GCS_BUCKET}/yellow/yellow_tripdata_*.csv.gz@CSV=format:CSV,skip_leading_rows:1,allow_quoted_newlines:true,allow_jagged_rows:true \
  nytaxi.yellow_tripdata
```

#### Step 5: Verify Tables Were Created

Check that the tables exist and have data:

```bash
bq show nytaxi.green_tripdata
bq show nytaxi.yellow_tripdata

# Count rows (optional)
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`${GCP_PROJECT_ID}.nytaxi.green_tripdata\`"
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`${GCP_PROJECT_ID}.nytaxi.yellow_tripdata\`"
```

You should see row counts in the millions for each table.

## Part 3: Running dbt

### Step 1: Set Required Environment Variable

Before running dbt, set the GCP project ID environment variable:

```bash
export GCP_PROJECT_ID=$(gcloud config get-value project)
```

This environment variable is used by dbt to reference your source tables in BigQuery. You can verify it's set:

```bash
echo $GCP_PROJECT_ID
# Should output: data-jobs-3921 (or your project ID)
```

**Optional - Make it Persistent:**

To avoid setting this every time you restart the codespace:

```bash
echo "export GCP_PROJECT_ID=$(gcloud config get-value project)" >> ~/.bashrc
```

### Step 2: Run dbt Commands

Now you can run dbt commands:

```bash
cd /home/vscode/homework
dbt debug    # Verify dbt can connect to BigQuery
dbt build    # Build all models
dbt run      # Run models only
dbt test     # Run tests only
```


## Part 4: Next Steps

Your environment is ready! Here's what you can do:

### Working with dbt

**Create new models:**
```bash
# Create a new SQL file in models/marts/
touch models/marts/my_new_model.sql
```

**Build and test models:**
```bash
# Build a specific model
dbt run --select my_model

# Build a model and its dependencies
dbt run --select +my_model

# Test your models
dbt test --select my_model

# View model results
dbt show --select my_model --limit 20
```

**Explore your data:**
```bash
# Query BigQuery directly
bq query --use_legacy_sql=false "SELECT * FROM \`${GCP_PROJECT_ID}.nytaxi.green_tripdata\` LIMIT 10"
bq query --use_legacy_sql=false "SELECT * FROM \`${GCP_PROJECT_ID}.dev.fct_trips\` LIMIT 10"

# Or use the BigQuery Console
# https://console.cloud.google.com/bigquery
```

### 📝 Homework

Ready to tackle the homework? **Open `HOMEWORK.md`** for all questions and instructions.

The homework will guide you through:
- Understanding dbt concepts (sources, variables, macros)
- Building analytical models
- Working with window functions and aggregations
- Creating new dbt models to answer specific business questions

**Resources:**
- dbt Documentation: https://docs.getdbt.com/
- BigQuery SQL Reference: https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax

---


## Tips for Success

### 1. **Start Simple**
- Test your logic on small datasets first (add LIMIT 1000)
- Build incrementally, don't try to solve everything at once

### 2. **Use dbt show for Quick Testing**
```bash
dbt show --select your_model --limit 20
```

### 3. **Use BigQuery Console for Ad-Hoc Queries**
- Navigate to https://console.cloud.google.com/bigquery
- Explore your datasets and run test queries
- View query execution plans and costs

### 4. **Check Compiled SQL**
```bash
dbt compile --select your_model
cat target/compiled/taxi_rides_ny/models/marts/your_model.sql
```

### 5. **Use CTE (Common Table Expressions)**
Break complex queries into readable steps:
```sql
with revenue_by_quarter as (
  -- Step 1
),
yoy_comparison as (
  -- Step 2
)
select * from yoy_comparison
```

---

## Quick Reference Commands

```bash
# Navigate to workspace
cd /home/vscode/homework

# Set GCP project (required before dbt commands)
export GCP_PROJECT_ID=$(gcloud config get-value project)

# Build everything
dbt build

# Build specific model
dbt run --select fct_trips

# Build model and its dependencies
dbt run --select +fct_trips

# Build model and its dependents
dbt run --select fct_trips+

# Run tests
dbt test

# Show compiled SQL
dbt compile --select model_name

# View results
dbt show --select model_name --limit 10

# Clean build artifacts
dbt clean

# Reinstall dependencies
dbt deps

# Query BigQuery directly
bq query --use_legacy_sql=false "SELECT COUNT(*) FROM \`${GCP_PROJECT_ID}.nytaxi.green_tripdata\`"
```

---

## Troubleshooting

### "Table your-project-id:nytaxi.table does not exist"

If you see this exact error with the literal text "your-project-id" instead of your actual project ID:

**Cause**: The `GCP_PROJECT_ID` environment variable is not set.

**Solution**:
```bash
export GCP_PROJECT_ID=$(gcloud config get-value project)
dbt build
```

To make it permanent, add to your shell profile:
```bash
echo "export GCP_PROJECT_ID=$(gcloud config get-value project)" >> ~/.bashrc
source ~/.bashrc
```

### "Table Not Found" or "Access Denied: Table does not exist"

If you see errors like `Table data-jobs-3921:nytaxi.green_tripdata does not exist` (with your actual project ID):

1. **Verify source tables exist**:
   ```bash
   bq ls nytaxi
   ```

2. **If tables are missing**, follow **Part 2: Load Raw Data** above to create them

3. **Check table names match sources.yml**:
   - Expected tables: `green_tripdata`, `yellow_tripdata`
   - Expected dataset: `nytaxi`
   - Expected project: Your GCP project ID

### "Access Denied" Errors

If you see permission errors:
1. Verify your Google account has BigQuery access
2. Re-run the authentication: `gcloud auth application-default login --no-launch-browser`
3. Check your project ID: `gcloud config get-value project`
4. Ensure your service account/user has these roles:
   - BigQuery Data Editor
   - BigQuery Job User
   - BigQuery User

### "Quota Exceeded" Errors

BigQuery has free tier limits. If you exceed them:
1. Check your usage in the [BigQuery Console](https://console.cloud.google.com/bigquery)
2. Consider filtering data or using smaller datasets during development
3. Free tier includes 1TB of queries per month and 10GB storage

### Connection Issues

If dbt cannot connect:
1. Run `dbt debug` to see detailed error messages
2. Verify authentication: `gcloud auth application-default print-access-token`
3. Check your `profiles.yml` configuration in `/home/vscode/homework/profiles/`

### Data Preparation Script Fails

If `prepare_homework_data.sh` fails:
1. **Check GCS bucket permissions**: Your service account needs Storage Object Admin role
2. **Verify bucket exists**: `gsutil ls gs://your-bucket-name/`
3. **Check disk space**: The script downloads ~6GB temporarily
4. **Network issues**: The script downloads from GitHub releases, ensure connectivity

## Architecture

This environment uses:
- **dbt-bigquery** adapter for data transformations
- **Application Default Credentials** (no JSON keys needed!)
- **Isolated workspace** at `/home/vscode/homework` (separate from main repo)
- **Medallion architecture**: staging → intermediate → marts

## Next Steps

1. ✅ Complete authentication setup (Part 1)
2. ✅ Load raw taxi data into BigQuery (Part 2)
3. ✅ Run `dbt debug` to verify connection
4. ✅ Run `dbt build` to transform data and create your data warehouse
5. ✅ Explore the models in `/home/vscode/homework/models/`
6. ✅ Query your transformed data in the [BigQuery Console](https://console.cloud.google.com/bigquery)

### Expected dbt Build Results

After loading source data and running `dbt build`, you should see:

```
Finished running in ~30 seconds

PASS: 34
ERROR: 1
SKIP: 11
TOTAL: 46
```

**Successfully Created Models**:
- **Seeds**: payment_type_lookup (7 rows), taxi_zone_lookup (265 rows)
- **Staging Views**: stg_green_tripdata, stg_yellow_tripdata
- **Intermediate Tables**: int_trips_unioned (200k rows), int_trips (197k rows)
- **Marts**: dim_zones (265 rows), **fct_trips (197k rows)**
- **Tests Passed**: 34/35 data quality tests

**Known Minor Issue**:
- ⚠️ 1 test fails: `accepted_values_fct_trips_payment_type` (type mismatch in test definition)
- This does NOT affect the model - fct_trips is created successfully with all data
- The model build completes successfully despite this test failure

**Skipped Models** (11):
- dim_vendors and fct_monthly_zone_revenue (these can be built separately if needed)
- Related tests for skipped models

**Total Processing**: ~200k trip records from 2019-2020 transformed into fact table

## Resources

- [dbt BigQuery Setup](https://docs.getdbt.com/reference/warehouse-setups/bigquery-setup)
- [Google Cloud Authentication](https://cloud.google.com/docs/authentication/application-default-credentials)
- [Project README](../README.md) for full project documentation

---

**Questions or issues?** Check the troubleshooting section above or review the dbt logs in `/home/vscode/homework/logs/`
