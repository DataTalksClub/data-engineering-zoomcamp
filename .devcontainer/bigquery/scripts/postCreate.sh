#!/usr/bin/env bash
set -euo pipefail

DEST_DIR="/home/vscode/homework"

# Debug logging
exec > >(tee -a "$DEST_DIR/setup.log") 2>&1
echo "Starting AE Homework: Cloud (BigQuery) setup..."
date

# 1. Run common setup (Repo root detection, File promotion, VS Code settings)
bash /opt/devcontainer/scripts/common_setup.sh

# 2. Copy variant-specific profiles
echo "Copying BigQuery profiles..."
mkdir -p "$DEST_DIR/profiles"
cp "/opt/devcontainer/bigquery/dbt/profiles.yml" "$DEST_DIR/profiles/"

# 3. Diagnostics and Deps
echo "dbt Version:"
dbt --version
cd "$DEST_DIR"
dbt deps || echo "dbt deps failed (expected if no profile/creds yet)."

echo "------------------------------------------------------------------"
echo "Environment Ready!"
echo "Workspace: $DEST_DIR"
echo ""
echo "!!! CLOUD AUTHENTICATION REQUIRED !!!"
echo "To connect to BigQuery, run: gcloud auth application-default login"
echo ""
echo "After authenticating, run this script to sync data to your GCS bucket:"
echo "  bash setup/prepare_homework_data.sh"
echo "------------------------------------------------------------------"
