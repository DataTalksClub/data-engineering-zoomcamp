#!/usr/bin/env bash
set -euo pipefail

# This script verifies the health and setup of a Data Engineering Zoomcamp Codespace.
# Usage: bash scripts/verify_codespace.sh <codespace-name>

CODESPACE_NAME="${1:-}"

if [[ -z "$CODESPACE_NAME" ]]; then
    echo "Error: Codespace name is required."
    echo "Usage: bash scripts/verify_codespace.sh <codespace-name>"
    echo "Run 'gh codespace list' to find active codespaces."
    exit 1
fi

echo "🔍 Verifying Codespace: $CODESPACE_NAME"
echo "------------------------------------------------------------------"

# 1. Check Workspace Root and File Promotion
echo "[1/5] Checking workspace isolation and file promotion..."
gh codespace ssh -c "$CODESPACE_NAME" -- "ls -F /home/vscode/homework" | grep -E "dbt_project.yml|setup/|HOMEWORK.md" > /dev/null
echo "✅ Workspace correctly isolated and dbt project promoted to root."

# 2. Check VS Code Settings
echo "[2/5] Checking workspace-level VS Code settings..."
gh codespace ssh -c "$CODESPACE_NAME" -- "cat /home/vscode/homework/.vscode/settings.json" | grep "dbt.executablePath" > /dev/null
echo "✅ Workspace settings found and pre-configured for dbt."

# 3. Check Virtual Environment
echo "[3/5] Checking Python virtual environment..."
gh codespace ssh -c "$CODESPACE_NAME" -- "/opt/venv/bin/python --version && /opt/venv/bin/dbt --version" > /dev/null
echo "✅ Virtual environment found at /opt/venv with dbt installed."

# 4. Check dbt Connectivity
echo "[4/5] Testing dbt connection (dbt debug)..."
gh codespace ssh -c "$CODESPACE_NAME" -- "cd /home/vscode/homework && /opt/venv/bin/dbt debug" > /dev/null
echo "✅ dbt debug passed (profiles.yml and project linked correctly)."

# 5. Check Data Loading Status
echo "[5/5] Checking background data loading progress..."
gh codespace ssh -c "$CODESPACE_NAME" -- "tail -n 5 /home/vscode/homework/setup.log"
echo "------------------------------------------------------------------"
echo "🚀 Verification Complete! The environment is healthy."
echo "Note: If the data loading is still in progress, run 'tail -f setup.log' inside the Codespace."
