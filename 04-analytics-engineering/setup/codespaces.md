# GitHub Codespaces (Devcontainer) Setup

You can run the Analytics Engineering module in **GitHub Codespaces** using one of the two environments below. Both setups come pre-installed with Python, dbt, and necessary extensions.

> [!TIP]
> **Prefer the Web Editor?** If Codespaces keeps opening in your local VS Code desktop app, you can change your default preference to "Visual Studio Code for Web" in your [GitHub Settings](https://github.com/settings/codespaces).

## Option 1: Local Setup (DuckDB)

**Recommended for:** Quick start, no cloud costs, learning dbt core concepts.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new/lassebenni/data-engineering-zoomcamp/tree/feat/devcontainer?quickstart=1&devcontainer_path=.devcontainer%2Fduckdb%2Fdevcontainer.json&editor=web)

**Includes:**
* `dbt-duckdb` adapter
* Local DuckDB database file
* Pre-configured `profiles.yml`
* Ingestion script for taxi data

## Option 2: Cloud Setup (BigQuery)

**Recommended for:** Production-like experience, using Google Cloud Platform (requires GCP account).

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new/lassebenni/data-engineering-zoomcamp/tree/feat/devcontainer?quickstart=1&devcontainer_path=.devcontainer%2Fbigquery%2Fdevcontainer.json&editor=web)

**Includes:**

* `dbt-bigquery` adapter
* Google Cloud SDK
* Pre-configured `profiles.yml` (requires `gcp_key.json`)

---

## Getting Started

1. Click the badge for your preferred environment.
2. Wait for the Codespace to build. **Note:** The environment will open in an isolated workspace containing only the relevant files for this module.
3. **Run dbt:**
   For the **Local (DuckDB)** environment, the taxi data is already pre-loaded! You can start immediately:
   ```bash
   dbt build
   ```

   For the **Cloud (BigQuery)** environment, you can optionally use the helper script to upload the required data to your GCS bucket:
   ```bash
   bash setup/prepare_homework_data.sh
   ```
