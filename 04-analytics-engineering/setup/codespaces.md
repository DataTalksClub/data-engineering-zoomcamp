# GitHub Codespaces (Devcontainer) Setup

You can run the Analytics Engineering module in **GitHub Codespaces** using DuckDB. The environment comes pre-installed with Python, dbt, and necessary extensions.

> [!TIP]
> **Prefer the Web Editor?** If Codespaces keeps opening in your local VS Code desktop app, you can change your default preference to "Visual Studio Code for Web" in your [GitHub Settings](https://github.com/settings/codespaces).

## DuckDB Setup

**Recommended for:** Quick start, no cloud costs, learning dbt core concepts.

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new/lassebenni/data-engineering-zoomcamp?quickstart=1&devcontainer_path=.devcontainer%2Fduckdb%2Fdevcontainer.json&ref=feat%2Fdevcontainer&editor=web)

**Includes:**
* `dbt-duckdb` adapter
* Local DuckDB database file with pre-loaded taxi data
* Pre-configured `profiles.yml`
* All dependencies installed

---

## Getting Started

1. Click the badge above to launch your codespace.
2. Wait for the Codespace to build. **Note:** The environment will open in an isolated workspace containing only the relevant files for this module.
3. **Run dbt:** The taxi data is already pre-loaded! You can start immediately:
   ```bash
   dbt build
   ```
