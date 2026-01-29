#!/usr/bin/env bash
set -euo pipefail

# Script to download only necessary taxi data for Module 4 homework
# Downloads selective CSV.gz files directly from GitHub releases and loads into DuckDB

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

DB_PATH="${1:-/home/vscode/homework/taxi_rides_ny.duckdb}"
BASE_URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

log "Starting selective data download for homework..."
log "Database path: $DB_PATH"

# Create temp directory for downloads
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

log "Temporary directory: $TEMP_DIR"

# Initialize DuckDB with prod schema
log "Initializing DuckDB database..."
duckdb "$DB_PATH" "CREATE SCHEMA IF NOT EXISTS prod;"

# ============================================
# Green Taxi: 2019-2020 (for Q5 YoY comparison and Q6)
# ============================================
log "Loading Green Taxi 2019-2020 data (24 months)..."
log "This covers Question 5 (YoY growth) and Question 6 (April 2020 percentiles)"

# DuckDB can read CSV.gz files directly from HTTPS URLs!
duckdb "$DB_PATH" <<SQL
CREATE OR REPLACE TABLE prod.green_tripdata AS
SELECT * FROM read_csv([
    -- 2019 (for YoY baseline)
    '${BASE_URL}/green/green_tripdata_2019-01.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-02.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-03.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-04.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-05.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-06.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-07.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-08.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-09.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-10.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-11.csv.gz',
    '${BASE_URL}/green/green_tripdata_2019-12.csv.gz',
    -- 2020 (for YoY comparison)
    '${BASE_URL}/green/green_tripdata_2020-01.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-02.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-03.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-04.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-05.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-06.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-07.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-08.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-09.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-10.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-11.csv.gz',
    '${BASE_URL}/green/green_tripdata_2020-12.csv.gz'
], auto_detect=true, compression='gzip');
SQL

GREEN_COUNT=$(duckdb "$DB_PATH" "SELECT COUNT(*) FROM prod.green_tripdata;" -csv -noheader)
log "Green Taxi loaded: $GREEN_COUNT records"

# ============================================
# Yellow Taxi: 2019-2020 (for Q5 YoY comparison and Q6)
# ============================================
log "Loading Yellow Taxi 2019-2020 data (24 months)..."
log "This covers Question 5 (YoY growth) and Question 6 (April 2020 percentiles)"

duckdb "$DB_PATH" <<SQL
CREATE OR REPLACE TABLE prod.yellow_tripdata AS
SELECT * FROM read_csv([
    -- 2019 (for YoY baseline)
    '${BASE_URL}/yellow/yellow_tripdata_2019-01.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-02.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-03.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-04.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-05.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-06.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-07.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-08.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-09.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-10.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-11.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2019-12.csv.gz',
    -- 2020 (for YoY comparison)
    '${BASE_URL}/yellow/yellow_tripdata_2020-01.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-02.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-03.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-04.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-05.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-06.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-07.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-08.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-09.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-10.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-11.csv.gz',
    '${BASE_URL}/yellow/yellow_tripdata_2020-12.csv.gz'
], auto_detect=true, compression='gzip');
SQL

YELLOW_COUNT=$(duckdb "$DB_PATH" "SELECT COUNT(*) FROM prod.yellow_tripdata;" -csv -noheader)
log "Yellow Taxi loaded: $YELLOW_COUNT records"

# ============================================
# FHV: November 2019 only (for Q7)
# ============================================
log "Loading FHV November 2019 data..."
duckdb "$DB_PATH" <<SQL
CREATE OR REPLACE TABLE prod.fhv_tripdata AS
SELECT * FROM read_csv('${BASE_URL}/fhv/fhv_tripdata_2019-11.csv.gz', auto_detect=true, compression='gzip');
SQL

FHV_COUNT=$(duckdb "$DB_PATH" "SELECT COUNT(*) FROM prod.fhv_tripdata;" -csv -noheader)
log "FHV loaded: $FHV_COUNT records"

# ============================================
# Summary
# ============================================
log ""
log "════════════════════════════════════════════════════════════"
log "✅ Data download and loading complete!"
log "════════════════════════════════════════════════════════════"
log ""
log "Database: $DB_PATH"
log "Size: $(du -h "$DB_PATH" | cut -f1)"
log ""
log "Records loaded:"
log "  - Green Taxi (2019-2020):  $GREEN_COUNT"
log "  - Yellow Taxi (2019-2020): $YELLOW_COUNT"
log "  - FHV (Nov 2019):          $FHV_COUNT"
log "  - TOTAL:                   $((GREEN_COUNT + YELLOW_COUNT + FHV_COUNT))"
log ""
log "Coverage:"
log "  ✅ Question 5: Quarterly revenue YoY (2019-2020 ✅)"
log "  ✅ Question 6: Fare percentiles (April 2020 ✅)"
log "  ✅ Question 7: FHV travel time (November 2019 ✅)"
log ""
log "Note: Downloads only necessary months for homework (49 CSV files)"
log "instead of full dataset, with same homework answer accuracy."
log ""
log "You can now run: dbt build --target prod"
log "════════════════════════════════════════════════════════════"
