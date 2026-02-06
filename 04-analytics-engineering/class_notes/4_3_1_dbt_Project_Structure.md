# DE Zoomcamp 4.3.1 — dbt Project Structure

> 📄 Video: [dbt Project Structure](https://www.youtube.com/watch?v=2dYDS4OQbT0)  
> 📄 Official docs: [About dbt projects](https://docs.getdbt.com/docs/build/projects)  
> 📄 Best practices: [How we structure our dbt projects](https://docs.getdbt.com/best-practices/how-we-structure/1-guide-overview)

When you run `dbt init`, dbt automatically creates a set of files and folders. This video walks through each one and explains its purpose. The structure below applies to both dbt Core and dbt Cloud (the DuckDB database file and `data/` folder are local-only artifacts and can be ignored here).

---

## Top-Level Files & Folders

### `analysis/`
- A place for **ad-hoc SQL scripts** that you don't necessarily want to share with stakeholders
- Not heavily used by everyone, but handy for things like **data quality reports** or **administrative checks**
- Think of it as a scratchpad — if you want to investigate how bad a data quality issue is, drop a SQL script here

### `dbt_project.yml`
- **The most important file in a dbt project**
- Every time you run a dbt command, dbt looks for this file first — if it's missing, the command fails
- Key things it contains:
  - Project name
  - Profile name (must match your `profiles.yml` — critical for dbt Core users)
  - Default materializations
  - Variables
- Also a place to set project-wide defaults and configuration

> 📄 [dbt_project.yml reference](https://docs.getdbt.com/reference/dbt_project.yml)

### `macros/`
- Macros behave like **reusable functions** (similar to Python functions or UDFs)
- Use them when you find yourself **repeating the same SQL logic** in multiple places, or when you want to **encapsulate a piece of logic** in one place
- Benefits:
  - Easier to test (you're testing a small, isolated chunk)
  - If a definition changes, you only update it in one place
- Common use cases:
  - **Calendar conversions** (e.g. converting standard dates to a company's fiscal calendar)
  - **Tax rates or regulatory definitions** that might change over time
  - Any reusable business logic that shouldn't be duplicated across models

> 📄 [Jinja and macros](https://docs.getdbt.com/docs/build/jinja-macros)

### `models/`
- The **most important directory** — this is where all your SQL transformation logic lives
- dbt suggests breaking it into **three subfolders** (see below)

### `README.md`
- Standard project documentation — the first thing someone sees when they open your project
- dbt creates a default one, but most teams customize it
- Good things to include:
  - How to run the project
  - Whether you need credentials or onboarding
  - Contact information
  - Installation/setup guides

### `seeds/`
- A place to **upload CSV or flat files** and ingest them as dbt models in your database
- Considered a **quick-and-dirty** approach — if you have the option, it's better to load data properly at the source
- Useful for:
  - **Lookup tables**
  - Quick experiments or prototypes
  - Showing a stakeholder something before fully committing to a data load
- Use when you don't have the right permissions, or the data is expected to change frequently during experimentation

> 📄 [Seeds](https://docs.getdbt.com/docs/build/seeds)

### `snapshots/`
- Solves a specific problem: a source table has a column that **overwrites itself**, but you need to **keep the history**
- Example: an `orders` table with a `current_status` column that only ever shows the latest status. For analytics, you want to know *when* each status changed
- How it works: a snapshot takes a **"picture" of a table at a point in time**. Each time you run it, if a value has changed, a new row is recorded with a timestamp — without overwriting the previous value
- Like seeds, this is a **workaround** — ideally you'd solve this at the source. But if you don't control the source, snapshots work well

> 📄 [Snapshots](https://docs.getdbt.com/docs/build/snapshots)

### `tests/`
- A place for **singular tests** written as SQL assertions
- The logic is simple: **if the query returns more than zero rows, the dbt build fails**
- Example from the course: a client needed to ensure that vehicle timestamps always covered exactly 24 hours per day. A test query checked for any day where the total hours deviated from 24 — catching logic errors like accidental filters or bad joins early
- This is one of several ways to test in dbt, but singular tests are especially good for **custom business rules** that don't fit standard schema tests

> 📄 [Data tests (singular & generic)](https://docs.getdbt.com/docs/build/data-tests)

---

## The `models/` Subfolders

dbt suggests organizing models into three layers:

### `staging/`
- Contains two things:
  - **Source definitions** — telling dbt where your raw data lives in the database
  - **Staging models** — a **1:1 copy** of each source table with only **minimal cleaning** applied
- Minimal cleaning means things like:
  - Fixing data types
  - Renaming columns
  - Filtering out clearly empty rows
  - Removing unnecessary columns
  - Standardizing values
- Keep it **1:1** — same number of rows and columns as the raw source. Breaking this rule is occasionally convenient but should be the exception

### `intermediate/`
- Everything that is **not raw** and **not ready to expose** to end users
- A catch-all for:
  - Complex joins
  - Heavy-duty cleaning or standardization
  - Data quality processing
- No strict guidelines on what goes here — if it doesn't fit neatly into staging or marts, it belongs in intermediate

### `marts/`
- Where all the **final, consumption-ready** tables live
- If it's in marts, it's **ready for end users**
- In a well-governed dbt project, **only marts tables should be exposed** to BI tools, analysts, and business stakeholders — nothing else
- Typically contains:
  - Tables ready for dashboards
  - Properly modeled, clean tables
  - Often star schemas, but not necessarily

---

## A Note on Conventions

The `staging → intermediate → marts` structure is dbt's recommendation, but it's not mandatory. The instructor has seen teams use:
- **Medallion architecture** naming: `bronze`, `silver`, `gold`
- Numbered layers: `first`, `second`, `third`, `last`
- Other custom conventions

If your organization already has a convention, follow it. Otherwise, stick with dbt's default structure — it's well thought out and what this course uses.