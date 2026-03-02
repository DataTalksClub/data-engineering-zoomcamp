---
alwaysApply: false
description: Information about dlt
globs: '**/*.py'
---

# Guidelines
1. dlt means "data load tool". It is an open source Python library installable via `pip install dlt`.
2. To create a new pipeline, use `dlt init <source> <destination>`.
3. The dlt library comes with the `dlt` CLI. Add the `--help` flag to any command to verify its specs. 
4. The preferred way to configure dlt (sources, resources, destinations, etc.) is to use `.dlt/config.toml` and `.dlt/secrets.toml`
5. During development, always set `dev_mode=True` when creating a dlt Pipeline. `pipeline = dlt.pipeline(..., dev_mode=True)`. This allows to reset the pipeline's schema and state between iterations.
6. Use type annotations only if you're certain you're properly importing the types.
7. Use dlt's REST API source if loading data from the web.
8. Use dlt's SQL source when loading data from an SQL database or backend.
9. Use dlt's filesystem source if loading data from files (CSV, PDF, Parquet, JSON, and more). This works for local filesystems and cloud buckets (AWS, Azure, GCP, Minio, etc.).