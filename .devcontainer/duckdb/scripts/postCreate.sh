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

# 3. Download selective CSV files for homework
DB_DEST="$DEST_DIR/taxi_rides_ny.duckdb"

if [[ ! -f "$DB_DEST" ]]; then
    echo "Loading taxi data for homework (selective download)..."
    echo "Downloading 49 CSV files (2019-2020 data, ~2.5 min)..."
    echo ""

    # Run the selective download script
    bash /opt/devcontainer/duckdb/scripts/download_homework_data.sh "$DB_DEST"
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
