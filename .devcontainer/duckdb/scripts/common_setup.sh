#!/usr/bin/env bash
set -euo pipefail

# This script handles shared setup tasks for all Data Engineering Zoomcamp Codespace variants.
# It promotes the project to the isolated root and configures VS Code.

DEST_DIR="/home/vscode/homework"
REPO_ROOT="/workspaces/data-engineering-zoomcamp"

# 1. Identify Repo Root (Robust Detection)
if [[ ! -d "$REPO_ROOT" ]]; then
    REPO_ROOT=$(find /workspaces -mindepth 1 -maxdepth 1 -type d -not -name ".*" -not -name "lost+found" | head -n 1)
fi

echo "Detected repository root: $REPO_ROOT"

# 2. Promote dbt project to root
AE_DIR="$REPO_ROOT/04-analytics-engineering"
DBT_PROJECT_DIR="$AE_DIR/taxi_rides_ny"

mkdir -p "$DEST_DIR"
if [[ -d "$DBT_PROJECT_DIR" ]]; then
    echo "Promoting dbt project contents to root..."
    cp -RT "$DBT_PROJECT_DIR/" "$DEST_DIR/"
else
    echo "Error: dbt project directory $DBT_PROJECT_DIR not found!"
    exit 1
fi

# 3. Copy essential shared files
cp "$AE_DIR/HOMEWORK.md" "$DEST_DIR/" 2>/dev/null || cp "$REPO_ROOT/cohorts/2023/week_4_analytics_engineering/homework.md" "$DEST_DIR/HOMEWORK.md"
mkdir -p "$DEST_DIR/setup"
cp -RT "$AE_DIR/setup/" "$DEST_DIR/setup/"

# 4. Initialize Git in the isolated workspace
echo "Initializing Git repository in $DEST_DIR..."
cd "$DEST_DIR"
git init -b main
git config user.email "student@dataengineering-zoomcamp.local"
git config user.name "DE Zoomcamp Student"
git add .
git commit -m "Initial commit: Isolated AE Homework environment"

# 5. Configure VS Code Settings from template
echo "Configuring workspace-level VS Code settings..."
mkdir -p "$DEST_DIR/.vscode"

# Determine variables based on environment
ADAPTER_NAME="dbt-duckdb"
EXTRA_COPILOT_INFO=""
if [[ -n "${IS_GCP_ENV:-}" ]]; then
    ADAPTER_NAME="dbt-bigquery"
    EXTRA_COPILOT_INFO="Use gcloud auth login or gcp_key.json for authentication."
fi

# Simple replacement using sed (instead of envsubst to keep dependencies minimal)
sed -e "s|\\\${ADAPTER_NAME}|$ADAPTER_NAME|g" \
    -e "s|\\\${EXTRA_COPILOT_INFO}|$EXTRA_COPILOT_INFO|g" \
    "/opt/devcontainer/scripts/settings.json.template" > "$DEST_DIR/.vscode/settings.json"

echo "Common setup complete."