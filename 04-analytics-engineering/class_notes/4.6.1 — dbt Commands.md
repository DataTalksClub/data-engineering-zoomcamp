# DE Zoomcamp 4.6.1 — dbt Commands

> 📄 Video: [dbt Commands](https://www.youtube.com/watch?v=t4OeWHW3SsA)  
> 📄 Official docs: [dbt command reference](https://docs.getdbt.com/reference/dbt-commands)  
> 📄 Selection syntax: [Node selection syntax](https://docs.getdbt.com/reference/node-selection/syntax)

We've been using dbt commands throughout the series without really stopping to talk about all of them. This video is the full tour — every command you'll actually use, plus the flags that make them powerful. Good one to bookmark.

---

## The setup commands — run these once (or when needed)

### dbt init

Creates your dbt project from scratch. Generates the full directory structure — `models/`, `seeds/`, `snapshots/`, `tests/`, `analysis/`, all of it. You only ever run this once, at the very start.

### dbt debug

Checks that your `profiles.yml` is valid and that dbt can actually connect to your warehouse. Run this whenever you're setting up a new environment or something feels off with your connection.

### dbt deps

Installs packages from your `packages.yml`. We covered this in 4.5.3 — just know it lives here in the command lineup too.

### dbt clean

Deletes the directories listed under `clean-targets` in your `dbt_project.yml`. By default that's `target/` and `dbt_packages/`. Useful for a fresh start, but remember you'll need to run `dbt deps` again after cleaning if you deleted `dbt_packages/`. You can add other directories to `clean-targets` if you want.

> 📄 [dbt clean — docs](https://docs.getdbt.com/reference/commands/clean)

---

## The feature-specific commands

These are tied to specific dbt features rather than being general-purpose.

### dbt seed

Loads all the CSVs in your `seeds/` directory into the warehouse. Quick and simple — great for reference data or small lookup tables.

### dbt snapshot

Runs any snapshots you've defined in your project. Snapshots are dbt's way of tracking how source data changes over time (think SCD Type 2). Not something you use every day, but it's there when you need it.

### dbt source freshness

Checks whether your source data is stale. If you've defined `freshness` blocks in your source YAML (we covered this in 4.5.2), this is the command that actually runs the check.

### dbt docs generate / dbt docs serve

`dbt docs generate` compiles your YAML documentation, model code, and warehouse metadata into a `catalog.json` artifact in `target/`. `dbt docs serve` spins up a local website (localhost:8080) so you can browse it. On dbt Cloud, `docs serve` isn't needed — it's handled automatically. For dbt Core users, finding a scalable way to host that docs site is something you'll need to sort out yourself.

> 📄 [dbt docs commands — docs](https://docs.getdbt.com/reference/commands/cmd-docs)

---

## The big four — these are your daily drivers

### dbt compile

Looks like it's doing nothing, but it's actually super useful. Takes all your models — with their Jinja, `ref()`, `source()` calls and everything — and outputs the fully resolved SQL into `target/compiled/`. No data moves, nothing hits the warehouse. It's just pure SQL sitting there for you to inspect.

Why bother? Two reasons. First, it's the fastest way to catch Jinja errors — way quicker than waiting for a full `dbt run`. Second, it's completely free — no compute, no warehouse cost. Good habit to run after making changes.

> 📄 [dbt compile — docs](https://docs.getdbt.com/reference/commands/compile)

### dbt run

Materializes every model in your project. Views become views, tables become tables, incremental models get incremental logic applied — whatever you configured. Models run in dependency order, so dbt figures out the sequence for you.

This is your go-to during active development when you just want to see your models built.

> 📄 [dbt run — docs](https://docs.getdbt.com/reference/commands/run)

### dbt test

Runs all the tests in your project — generic tests, singular tests, unit tests, all of it. Reports pass/fail at the end. Nothing gets built here, it just validates what's already in the warehouse.

> 📄 [dbt test — docs](https://docs.getdbt.com/reference/commands/test)

### dbt build ⭐

The most important command. It's a smart combination of `dbt run` + `dbt test` + `dbt seed` + `dbt snapshot`, all in one. But it's not just running them sequentially — it's DAG-aware. It knows the right order, and if something fails along the way, it skips everything downstream of that failure rather than wasting compute on models that are going to break anyway.

This is what you want for CI, production runs, or any time you need confidence that your whole project is solid.

> 📄 [dbt build — docs](https://docs.getdbt.com/reference/commands/build)

### dbt retry

If a `dbt build` or `dbt run` fails partway through, don't just re-run the whole thing from scratch. `dbt retry` re-executes from the point of failure by reading the `run_results.json` file from the previous run. It automatically identifies which nodes failed and re-runs those nodes plus everything downstream of them.

How it works:
- dbt looks at `target/run_results.json` from the last command
- It identifies failed nodes and skipped nodes (anything downstream of a failure)
- It re-runs only those nodes, reusing the same selection criteria from the original command
- If the previous command completed successfully, `dbt retry` finishes as a no-op

Saves a lot of time on big projects, especially when a single model fails deep in the DAG.

---

## Flags — the important ones

### --help / -h

Works on any command. `dbt --help` gives you the full list, `dbt run --help` gives you flags specific to `run`. Standard stuff, but worth knowing it's there.

### --version / -V

Tells you which version of dbt you have installed. Also lets you know if there's an update available.

### --full-refresh / -f

Used with `dbt run` or `dbt build`. When you have an incremental model, it normally just appends new rows. `--full-refresh` drops the whole thing and rebuilds from scratch. Handy when historical data has changed, you've got duplicates, or you just want to make sure everything is clean. Most teams do this on a regular schedule — maybe once a month — just to keep things tidy.

```bash
dbt run --full-refresh
```

### --fail-fast

Runs a stricter version of dbt. Normally warnings don't stop execution — with `--fail-fast` they do. Good for CI or any time you want to be sure nothing slips through. Better to fail loud than to be permissive and find surprises later.

### --target / -t

Controls which profile target dbt runs against. By default everything runs on `dev`. But you can override it:

```bash
dbt run --target prod
```

Works with `dbt run`, `dbt build`, `dbt test`, `dbt snapshot` — basically any command that touches the warehouse. Best practice: developers work in `dev`, production runs use `--target prod`.

### --select / -s

This is the big one. Lets you run only specific parts of your project instead of everything. There are a few ways to use it:

**By model name** — just give it the model name (no `.sql` needed):

```bash
dbt run --select stg_green_tripdata
```

**By directory path** — everything in a folder:

```bash
dbt run --select models/staging
```

**By tag:**

```bash
dbt run --select tag:nightly
```

**With graph operators (the + sign)** — this is where it gets really useful. The `+` lets you pull in upstream or downstream dependencies:

```bash
# Run stg_green_tripdata and all upstream dependencies
dbt run --select +stg_green_tripdata

# Run fct_trips and all downstream dependencies
dbt run --select fct_trips+

# Run dim_zones plus everything upstream AND downstream
dbt run --select +dim_zones+
```

- `+my_model` — builds `my_model` and everything upstream of it (all its ancestors)
- `my_model+` — builds `my_model` and everything downstream of it (all its descendants)
- `+my_model+` — both directions. Everything upstream, the model itself, and everything downstream

> 📄 [Graph operators — docs](https://docs.getdbt.com/reference/node-selection/graph-operators)

**With state selectors** — instead of guessing what changed, let dbt figure it out:

```bash
dbt build --select state:modified+ --state ./prod-artifacts
```

- `state:new` — only files you just created
- `state:modified` — anything that's changed since the last run
- Add `+` after to include downstream dependencies of modified models

How state comparison works:
- You need artifacts from a **previous run** stored somewhere persistent (not the same `target/` directory you're currently writing to)
- On **dbt Cloud**, this is handled automatically — production artifacts are stored and accessible for comparison
- On **dbt Core**, you need to manually store artifacts (especially `manifest.json`) somewhere — a cloud bucket, a separate directory, version control, etc.
- Point `--state` to where those previous artifacts live
- dbt compares your current code against those artifacts to determine what's new or modified

The key is that you're comparing against a *different environment's artifacts* (usually production) or a *previous point in time* — not against the directory you're currently building into. This lets you run only what's changed since your last production deployment, which is incredibly useful for CI/CD workflows.

Storing those JSON artifacts persistently is also just good practice in general — you can use them to analyze how your project evolves over time.

> 📄 [Node selection syntax — docs](https://docs.getdbt.com/reference/node-selection/syntax)