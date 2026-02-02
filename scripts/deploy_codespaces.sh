#!/usr/bin/env bash
set -euo pipefail

# Non-interactive Codespace Deployment Script
# Usage: bash scripts/deploy_codespaces.sh

REPO="lassebenni/data-engineering-zoomcamp"
BRANCH="feat/devcontainer"

echo "🚀 Starting non-interactive deployment..."

# 1. Create DuckDB Codespace (Standard instance for data baking/local processing)
echo "Creating AE Homework (DuckDB)..."
gh codespace create \
    --repo "$REPO" \
    --branch "$BRANCH" \
    --devcontainer-path ".devcontainer/duckdb/devcontainer.json" \
    --machine "standardLinux32gb"

# 2. Create BigQuery Codespace (Basic instance since processing is remote)
echo "Creating AE Homework (BigQuery)..."
gh codespace create \
    --repo "$REPO" \
    --branch "$BRANCH" \
    --devcontainer-path ".devcontainer/bigquery/devcontainer.json" \
    --machine "basicLinux32gb"

echo "------------------------------------------------------------------"
echo "✅ Deployment commands submitted!"
echo "Run 'gh codespace list' to monitor provisioning status."
echo "Once Available, use 'bash scripts/verify_codespace.sh <name>' to check health."
echo "------------------------------------------------------------------
