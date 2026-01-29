#!/usr/bin/env bash
set -euo pipefail

# Script to create BigQuery external tables from GCS data
# Run this after prepare_homework_data.sh has uploaded files to GCS

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Check required environment variables
if [[ -z "${GCP_PROJECT_ID:-}" ]]; then
    GCP_PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
    if [[ -z "$GCP_PROJECT_ID" || "$GCP_PROJECT_ID" == "(unset)" ]]; then
        echo "Error: GCP_PROJECT_ID is not set and could not be auto-detected"
        echo "Please run: export GCP_PROJECT_ID=your-project-id"
        exit 1
    fi
fi

if [[ -z "${GCP_GCS_BUCKET:-}" ]]; then
    echo "Error: GCP_GCS_BUCKET is not set"
    echo "Please run: export GCP_GCS_BUCKET=your-bucket-name"
    exit 1
fi

log "Creating BigQuery external tables for project: $GCP_PROJECT_ID"
log "Using GCS bucket: gs://$GCP_GCS_BUCKET"

# Create dataset if it doesn't exist
log "Creating/verifying nytaxi dataset..."
bq mk --dataset --location=US ${GCP_PROJECT_ID}:nytaxi 2>/dev/null || log "Dataset nytaxi already exists"

# Create green_tripdata external table
log "Creating green_tripdata external table..."
bq mk --force \
  --external_table_definition=gs://${GCP_GCS_BUCKET}/green/green_tripdata_*.csv.gz@CSV=format:CSV,skip_leading_rows:1,allow_quoted_newlines:true,allow_jagged_rows:true \
  nytaxi.green_tripdata

# Create yellow_tripdata external table
log "Creating yellow_tripdata external table..."
bq mk --force \
  --external_table_definition=gs://${GCP_GCS_BUCKET}/yellow/yellow_tripdata_*.csv.gz@CSV=format:CSV,skip_leading_rows:1,allow_quoted_newlines:true,allow_jagged_rows:true \
  nytaxi.yellow_tripdata

# Verify tables were created
log "Verifying tables..."
echo ""
echo "Green Tripdata:"
bq show nytaxi.green_tripdata
echo ""
echo "Yellow Tripdata:"
bq show nytaxi.yellow_tripdata

log "External tables created successfully!"
log "You can now run: dbt build"
