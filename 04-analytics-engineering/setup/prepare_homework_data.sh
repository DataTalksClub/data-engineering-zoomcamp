#!/usr/bin/env bash
set -e

# Disable Python output buffering so progress appears in logs immediately
export PYTHONUNBUFFERED=1

log_progress() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Define required datasets for Week 4 Homework
# Yellow 2019-2020, Green 2019-2020, FHV 2019

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

if [[ -n "${DBT_DUCKDB_PATH:-}" ]]; then
    log_progress "Creating DuckDB data for Analytics Engineering Homework..."
    
    # 1. Yellow & Green (2019-2020)
    log_progress "Step 1/2: Loading Yellow and Green Taxi Data (2019-2020)..."
    python ingest_taxi_data.py \
        --taxi-types yellow,green \
        --years 2019-2020 \
        --keep-csv-gz # Optional, but safer if connection drops

    # 2. FHV (2019)
    log_progress "Step 2/2: Loading FHV Data (2019)..."
    python ingest_taxi_data.py \
        --taxi-types fhv \
        --years 2019 \
        --keep-csv-gz

    log_progress "DuckDB Data Preparation Complete!"

elif [[ -n "${IS_GCP_ENV:-}" || -n "${GCP_PROJECT_ID:-}" ]]; then
    log_progress "Detected BigQuery Environment."

    # Try to auto-detect project ID if not set
    if [[ -z "${GCP_PROJECT_ID:-}" ]]; then
        AUTO_PROJECT=$(gcloud config get-value project 2>/dev/null)
        if [[ -n "$AUTO_PROJECT" && "$AUTO_PROJECT" != "(unset)" ]]; then
            export GCP_PROJECT_ID="$AUTO_PROJECT"
            log_progress "Auto-detected GCP Project ID: $GCP_PROJECT_ID"
        fi
    fi
    
    if [[ -z "${GCP_PROJECT_ID:-}" ]]; then
        echo "GCP_PROJECT_ID is not set."
        read -p "Enter your GCP Project ID: " USER_PROJECT
        if [[ -z "$USER_PROJECT" ]]; then
            echo "Error: Project ID is required."
            exit 1
        fi
        export GCP_PROJECT_ID="$USER_PROJECT"
    fi

    if [[ -z "${GCP_GCS_BUCKET:-}" ]]; then
        echo "GCP_GCS_BUCKET is not set."
        read -p "Enter your GCS Bucket Name (e.g., dtc-data-lake-12345): " USER_BUCKET
        if [[ -z "$USER_BUCKET" ]]; then
            echo "Error: Bucket name is required."
            exit 1
        fi
        export GCP_GCS_BUCKET="$USER_BUCKET"
    fi

    log_progress "Uploading data to gs://$GCP_GCS_BUCKET for project $GCP_PROJECT_ID..."
    
    # 1. Yellow & Green (2019-2020)
    python load_gcs_data.py \
        --taxi-types yellow,green \
        --years 2019-2020 \
        --bucket "$GCP_GCS_BUCKET"

    # 2. FHV (2019)
    python load_gcs_data.py \
        --taxi-types fhv \
        --years 2019 \
        --bucket "$GCP_GCS_BUCKET"

    log_progress "BigQuery Data Preparation Complete! (Data uploaded to GCS)"
    log_progress "Next steps: Create External Tables in BigQuery referencing these files."
    log_progress "You can now run 'dbt debug' to verify connection."

else
    echo "Error: Could not determine environment (DuckDB vs BigQuery)."
    echo "Please ensure you are running this from a configured Codespace or set DBT_DUCKDB_PATH / IS_GCP_ENV."
    exit 1
fi
