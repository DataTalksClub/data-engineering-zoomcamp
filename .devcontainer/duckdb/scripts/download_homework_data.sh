#!/usr/bin/env bash
set -euo pipefail

# Script to download only necessary taxi data for Module 4 homework
# Downloads CSV.gz files locally first, then loads into DuckDB to avoid GitHub rate limits

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

# Initialize DuckDB database (main schema exists by default)
log "Initializing DuckDB database..."

# Helper function to download a file
download_file() {
    local url="$1"
    local dest="$2"
    if command -v wget &> /dev/null; then
        wget -q -O "$dest" "$url" || {
            log "Failed to download $url"
            return 1
        }
    elif command -v curl &> /dev/null; then
        curl -sL -o "$dest" "$url" || {
            log "Failed to download $url"
            return 1
        }
    else
        log "Error: Neither wget nor curl found"
        return 1
    fi
}

# ============================================
# Green Taxi: 2019-2020 (for Q5 YoY comparison and Q6)
# ============================================
log "Downloading Green Taxi 2019-2020 data (24 files)..."
log "This covers Question 5 (YoY growth) and Question 6 (April 2020 percentiles)"

# Download all green taxi files
for year in 2019 2020; do
    for month in {01..12}; do
        filename="green_tripdata_${year}-${month}.csv.gz"
        log "  Downloading $filename..."
        download_file "${BASE_URL}/green/${filename}" "${TEMP_DIR}/${filename}"
    done
done

# Load all downloaded green files into DuckDB
log "Loading Green Taxi data into DuckDB..."
duckdb "$DB_PATH" "CREATE OR REPLACE TABLE main.green_tripdata AS SELECT * FROM read_csv('${TEMP_DIR}/green_tripdata_*.csv.gz', auto_detect=true, compression='gzip', filename=true);"

GREEN_COUNT=$(duckdb "$DB_PATH" "SELECT COUNT(*) FROM main.green_tripdata;" -csv -noheader)
log "Green Taxi loaded: $GREEN_COUNT records"

# Clean up green files to save space
rm -f "${TEMP_DIR}"/green_tripdata_*.csv.gz

# ============================================
# Yellow Taxi: 2019-2020 (for Q5 YoY comparison and Q6)
# ============================================
log "Downloading Yellow Taxi 2019-2020 data (24 files)..."
log "This covers Question 5 (YoY growth) and Question 6 (April 2020 percentiles)"

# Download all yellow taxi files
for year in 2019 2020; do
    for month in {01..12}; do
        filename="yellow_tripdata_${year}-${month}.csv.gz"
        log "  Downloading $filename..."
        download_file "${BASE_URL}/yellow/${filename}" "${TEMP_DIR}/${filename}"
    done
done

# Load all downloaded yellow files into DuckDB
log "Loading Yellow Taxi data into DuckDB..."
duckdb "$DB_PATH" "CREATE OR REPLACE TABLE main.yellow_tripdata AS SELECT * FROM read_csv('${TEMP_DIR}/yellow_tripdata_*.csv.gz', auto_detect=true, compression='gzip', filename=true);"

YELLOW_COUNT=$(duckdb "$DB_PATH" "SELECT COUNT(*) FROM main.yellow_tripdata;" -csv -noheader)
log "Yellow Taxi loaded: $YELLOW_COUNT records"

# Clean up yellow files to save space
rm -f "${TEMP_DIR}"/yellow_tripdata_*.csv.gz

# ============================================
# FHV: November 2019 only (for Q7)
# ============================================
log "Downloading FHV November 2019 data..."
download_file "${BASE_URL}/fhv/fhv_tripdata_2019-11.csv.gz" "${TEMP_DIR}/fhv_tripdata_2019-11.csv.gz"

log "Loading FHV data into DuckDB..."
duckdb "$DB_PATH" "CREATE OR REPLACE TABLE main.fhv_tripdata AS SELECT * FROM read_csv('${TEMP_DIR}/fhv_tripdata_2019-11.csv.gz', auto_detect=true, compression='gzip');"

FHV_COUNT=$(duckdb "$DB_PATH" "SELECT COUNT(*) FROM main.fhv_tripdata;" -csv -noheader)
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
log "You can now run: dbt build"
log "════════════════════════════════════════════════════════════"
