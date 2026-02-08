# Troubleshooting DuckDB Out of Memory Errors

If you're getting `Out of Memory` errors while running dbt build commands, don't panic. This is a common issue, especially on machines with limited RAM. This guide explains why it happens and what you can do about it.

## Why does this happen?

DuckDB is an **in-process database**, which means it runs inside your computer's memory (RAM) rather than on a remote server. The NYC taxi dataset we use in this project contains **tens of millions of rows** across 24 months of yellow and green taxi data. When dbt builds models, DuckDB needs to load, transform, and write this data (all using your local RAM).

Some operations are more memory-intensive than others:

| Operation | Why it's expensive | Where it happens |
|---|---|---|
| `QUALIFY` with window functions | Requires sorting and partitioning the entire dataset in memory | `int_trips.sql` (deduplication) |
| `UNION ALL` on large tables | Combines two large datasets into one | `int_trips_unioned.sql` |
| Surrogate key generation (`generate_surrogate_key`) | Computes hashes across the full dataset | `int_trips.sql` |
| `JOIN` on large fact tables | Expands memory footprint when enriching trips with zones | `fct_trips.sql` |

## Step 1: Check your available RAM

Before troubleshooting, know what you're working with. You can generally find this in your settings menu.

As a rule of thumb:

- **4 GB RAM**: You will very likely hit OOM. Follow all the steps below.
- **8 GB RAM**: You might hit OOM on some models. Adjust memory settings.
- **16+ GB RAM**: You should be fine with default settings.

## Step 2: Adjust DuckDB memory settings in `profiles.yml`

Your `~/.dbt/profiles.yml` controls how much memory DuckDB can use. Here's what you can tune:

- **`memory_limit`**: By default, DuckDB will try to use up to 80% of your system's RAM. That sounds reasonable, but your operating system, browser, IDE, and other apps also need memory. If DuckDB claims too much, the OS may kill the process — that's your OOM error. Setting an explicit limit (roughly **50% of your total RAM**) leaves enough room for everything else. So if you have 8 GB, try `'4GB'`.
- **`threads`**: This controls how many models dbt builds in parallel. But it also affects DuckDB's internal parallelism. Lowering `threads` reduces peak memory usage. Try `2` or `1` if you're hitting OOM.
- **`preserve_insertion_order: false`**: Tells DuckDB it doesn't need to maintain row order, which saves memory.

## Step 3: Use `dbt retry` after a failure

If your `dbt build` fails partway through, you **don't need to rebuild everything from scratch**. Use:

```bash
dbt retry
```

This command picks up where the last run left off, only running the models that failed or were skipped. This is very useful when an OOM error kills a single model — fix the issue, then retry without re-running the models that already succeeded.

## Step 4: Build models selectively with `--select`

Instead of building the entire project at once, build one model at a time to reduce peak memory usage:

```bash
dbt build --select stg_yellow_tripdata --target prod
dbt build --select stg_green_tripdata --target prod
dbt build --select int_trips_unioned --target prod
dbt build --select int_trips --target prod
dbt build --select fct_trips --target prod
```

This way, DuckDB only needs to handle one model at a time.

## Step 5: Leverage incremental models

The `fct_trips` model in this project is already configured as **incremental**. This means that after the first full build, subsequent runs only process **new records** instead of reprocessing the entire dataset.

If your first full build fails due to OOM but some models succeeded, use `dbt retry` (Step 3). Once `fct_trips` is built for the first time, future runs will be much lighter on memory.

## Additional DuckDB performance tips

These tips come from [DuckDB's official performance guide](https://duckdb.org/docs/guides/performance/environment.html):

1. **Close other applications**: Browsers, IDEs, and other apps compete for RAM. Close what you don't need before running `dbt build`.
2. **Use an SSD**: DuckDB spills to disk when it runs out of memory. An SSD makes this spill-to-disk process much faster than an HDD.
3. **Avoid running inside Docker** (if possible): Docker containers have memory limits that may be lower than your system's total RAM. If you must use Docker, increase the container's memory limit.

## Still stuck?

If you've tried everything above and still can't build the project:

1. Ask for help in the [course Slack channel](https://datatalks-club.slack.com/). Include your RAM, OS, and the exact error message.
2. Consider using the **Cloud Setup (BigQuery)** path instead — BigQuery runs on Google's servers, so your local RAM doesn't matter. See the [Cloud Setup Guide](cloud_setup.md).
