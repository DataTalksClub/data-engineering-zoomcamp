# Analytics Engineering Homework Environment

Welcome to the **Analytics Engineering** module! This repository contains the isolated environment needed to complete the homework.

## 🚀 Getting Started

You are likely already in a GitHub Codespace. If not, click one of the options below to start:

*   **[Local Setup (DuckDB)](https://codespaces.new/lassebenni/data-engineering-zoomcamp/tree/feat/devcontainer?quickstart=1&devcontainer_path=.devcontainer%2Fduckdb%2Fdevcontainer.json&editor=web)** (Recommended)
*   **[Cloud Setup (BigQuery)](https://codespaces.new/lassebenni/data-engineering-zoomcamp/tree/feat/devcontainer?quickstart=1&devcontainer_path=.devcontainer%2Fbigquery%2Fdevcontainer.json&editor=web)**

## 📂 Project Structure

*   `04-analytics-engineering/`: Contains the `taxi_rides_ny` dbt project and models.
*   `04-analytics-engineering/HOMEWORK.md`: The homework instructions.

## 🛠 Usage

1.  **Run dbt**:
    ```bash
    dbt debug
    dbt build
    ```

Happy coding!