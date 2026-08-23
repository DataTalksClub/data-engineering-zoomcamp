# DE Zoomcamp 4.5.3 — dbt Packages

> 📄 Video: [dbt Packages](https://www.youtube.com/watch?v=KfhUA9Kfp8Y)  
> 📄 Official docs: [Packages](https://docs.getdbt.com/docs/build/packages)  
> 📄 Package Hub: [hub.getdbt.com](https://hub.getdbt.com)

One of the things that makes dbt's community so strong is packages. A dbt package is basically a self-contained dbt project — it has its own macros, tests, models, sources — but instead of using it yourself, you distribute it so other people can drop it into their own projects. Think Python libraries, but for dbt. This video covers the most useful packages out there and how to actually install and use them.

---

## Packages worth knowing about

### dbt-utils

The big one. Maintained by dbt Labs, so it's well-kept and safe to use. It bundles a ton of common SQL utilities as macros — things like generating surrogate keys, deduplicating, pivoting, safe division, extracting URL parameters. Stuff most of us have written ourselves at some point.

The real kicker is **cross-database compatibility**. dbt-utils macros compile down to the correct SQL dialect depending on your warehouse. So the same macro works on BigQuery, DuckDB, Snowflake, etc. — no need to maintain separate versions of your code.

### dbt-codegen

A massive time-saver for the YAML grind. Codegen does two things:

- **YAML from SQL** — point it at a model or source and it auto-generates the `schema.yml` with all the columns listed out. No more manually typing hundreds of column names.
- **SQL from YAML** — the reverse. Give it a YAML spec and it generates a staging model SQL file following dbt conventions (single CTE for renaming, proper file naming, etc.).

### dbt-project-evaluator

Scores your dbt project against best practices. Good for teams that want a quick sanity check on whether they're following conventions.

### dbt-audit-helper

Handy when you're refactoring. It compares an old model against a new one and validates that they produce the same results — same columns, same row counts, same values. Takes the anxiety out of rewriting existing SQL.

### dbt-expectations

This is the one that makes custom tests almost unnecessary. It's a massive library of pre-built generic tests covering almost every assertion you can think of — row counts, value ranges, consistent casing, regex matching, approximate equality, and way more. In practice, if you need to test something, there's a very good chance dbt-expectations already has it.

> 📄 [dbt-expectations on the Package Hub](https://hub.getdbt.com/calogica/dbt_expectations/latest/)

### Warehouse-specific packages

The hub has plenty of packages tailored to specific platforms — Snowflake, BigQuery, etc. These typically come with models or macros for monitoring spend, evaluating best practices, applying constraints, or working with platform-specific features like semantic views.

---

## A note on trust

Packages on the dbt Hub have gone through a vetting process by dbt Labs — they're generally safe to use. Packages you find floating around on GitHub that aren't on the Hub? Take a closer look at what they actually do before dropping them into your project.

---

## How to install a package — the demo

The video walks through installing dbt-utils and using it to generate surrogate keys. Here's the workflow:

### 1. Create packages.yml

At the root of your dbt project (same level as `dbt_project.yml`), create a file called `packages.yml`. Declare the package and pin the version.

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
```

### 2. Run `dbt deps`

This downloads and installs the package. After it runs, two things appear:

- A `package-lock.yml` file — contains a hash of exactly what was installed. Commit this to version control so everyone on your team gets the same versions.
- A `dbt_packages/` directory — this is where the installed package code lives. It's git-ignored by default (you don't want to commit other people's source code into your repo), but you can browse it if you're curious how the macros work.

### 3. Use it

Once installed, the package's macros are immediately available. You call them with the standard Jinja syntax, prefixing with the package name.

**Before (manual surrogate key):**
```sql
select
    -- Manual concatenation approach
    concat(
        cast(vendorid as string), '-',
        cast(lpep_pickup_datetime as string)
    ) as tripid,
    vendorid,
    pickup_datetime
from {{ source('staging', 'green_tripdata') }}
```

**After (using dbt_utils.generate_surrogate_key):**
```sql
select
    -- Clean, cross-database macro
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as tripid,
    vendorid,
    pickup_datetime
from {{ source('staging', 'green_tripdata') }}
```

That's it. The macro handles the rest — compiles to the right SQL for whatever warehouse you're targeting (MD5 hash for BigQuery, hash function for Snowflake, etc.).

> 📄 [dbt deps command — docs](https://docs.getdbt.com/reference/commands/deps)