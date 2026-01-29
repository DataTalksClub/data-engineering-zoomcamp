#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="/home/vscode/homework"

# Debug logging
exec > >(tee -a "$DEST_DIR/setup.log") 2>&1
echo "Starting AE Homework: Local (DuckDB) setup..."
date

# 1. Run common setup (Repo root detection, File promotion, VS Code settings)
bash /opt/devcontainer/scripts/common_setup.sh

# 2. Copy variant-specific profiles
echo "Copying DuckDB profiles..."
mkdir -p "$DEST_DIR/profiles"
cp "/opt/devcontainer/duckdb/dbt/profiles.yml" "$DEST_DIR/profiles/"

# 3. Download pre-built DuckDB database
DB_DEST="$DEST_DIR/taxi_rides_ny.duckdb"
DB_URL="https://github.com/lassebenni/data-engineering-zoomcamp/releases/download/v1.0.0/taxi_rides_ny.duckdb"

if [[ ! -f "$DB_DEST" ]]; then
    echo "Downloading pre-built taxi database (3.3GB)..."
    echo "This will take 2-4 minutes depending on network speed..."
    echo ""

    # Download with progress bar
    if command -v wget &> /dev/null; then
        wget --progress=bar:force --show-progress -O "$DB_DEST" "$DB_URL"
    elif command -v curl &> /dev/null; then
        curl -L --progress-bar -o "$DB_DEST" "$DB_URL"
    else
        echo "Error: Neither wget nor curl found. Cannot download database."
        exit 1
    fi

    echo ""
    echo "Download complete!"
    echo "Database contains:"
    echo "  - Green Taxi 2019-2020:  8,035,161 records"
    echo "  - Yellow Taxi 2019-2020: 109,247,536 records"
    echo "  - FHV 2019:              43,261,276 records"
else
    echo "Database already exists, skipping download."
fi

# 4. Diagnostics and Deps
echo "dbt Version:"
dbt --version
cd "$DEST_DIR"
dbt deps

# 5. Copy setup guide and open it
if [[ -f "/opt/devcontainer/duckdb/setup_guide.md" ]]; then
    echo "Copying setup guide..."
    cp "/opt/devcontainer/duckdb/setup_guide.md" "$DEST_DIR/SETUP_GUIDE.md"
    # Try to open the setup guide (will fail silently if not in VS Code)
    code "$DEST_DIR/SETUP_GUIDE.md" --reuse-window 2>/dev/null || true
fi

echo "------------------------------------------------------------------"
echo "Environment Ready!"
echo "Workspace: $DEST_DIR"
echo ""
echo "Taxi data (Yellow/Green 2019-2020, FHV 2019) has been pre-loaded."
echo "You can run 'dbt build' or 'dbt show' immediately."
echo ""
echo "📖 Setup guide: $DEST_DIR/SETUP_GUIDE.md"
echo "------------------------------------------------------------------"
