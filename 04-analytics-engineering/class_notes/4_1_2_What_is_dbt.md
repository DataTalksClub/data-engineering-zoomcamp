# DE Zoomcamp 4.1.2 — What is dbt?

> 📄 Video: [What is dbt?](https://www.youtube.com/watch?v=gsKuETFJr54)  
> 📄 Official docs: [Introduction to dbt](https://docs.getdbt.com/docs/introduction)  
> 📄 dbt Cloud vs Core: [Choose your dbt](https://docs.getdbt.com/docs/cloud/about-cloud/dbt-cloud-features)

This is the big-picture overview of dbt before we start building anything. What it is, what problems it solves, and how we'll be using it in the course. No hands-on work yet — just the framing.

---

## What is dbt?

dbt is a transformation workflow tool. It sits on top of your data warehouse and helps you turn raw data into something useful for downstream consumers (analysts, BI tools, ML pipelines, whatever needs clean, structured data).

You write SQL (or Python) to define your transformations, and dbt handles the rest: compiling it, running it against the warehouse, managing dependencies, and persisting the results as tables or views.

In a real company setup, you'd have data flowing in from all over the place — backend systems, frontend apps, third-party APIs like weather data. All of that gets loaded into your warehouse (BigQuery, Snowflake, Databricks, whatever), and dbt is the layer that transforms that raw data into something the business can actually consume.

---

## What problems it solves

The transformation step has always existed. What dbt brings to the table is **software engineering best practices for analytics code**. Things that software engineers have been doing for years but didn't have a clear path into the analytics world:

- **Version control** — your transformations live in git, just like any other code
- **Modularity** — break complex logic into reusable pieces instead of massive spaghetti queries
- **Testing** — automated data quality checks that run with every deployment
- **Documentation** — generated from your code, not a separate wiki that gets out of date
- **Environments** — separate dev and prod. Each developer gets their own sandbox to work in without stepping on each other's toes
- **CI/CD** — automated deployments with validation and rollback

The result is higher-quality pipelines that are easier to maintain and less prone to breaking in production.

---

## How it works — the mechanics

You write a SQL file. It looks like a normal `SELECT` statement. dbt takes that file, figures out where it should go in the warehouse (which schema, which dataset, what environment), wraps it in the necessary DDL/DML, compiles it with any Jinja templating you've used, and runs it.

When you run `dbt run`, it:
1. Compiles your SQL (resolves `ref()` calls, `source()` calls, Jinja macros, everything)
2. Sends the compiled SQL to your warehouse
3. Materializes the result as a table, view, incremental table, or ephemeral CTE — whatever you configured

You don't write `CREATE TABLE` statements yourself. You just write the `SELECT`, and dbt handles the rest.

---

## dbt Core vs dbt Cloud

There are two ways to use dbt, and it's worth understanding the difference:

### dbt Core

Open source. Free. You install it locally on your machine (or wherever) and run commands from the terminal. You're responsible for:

- Setting up your dev environment
- Orchestrating production runs (Airflow, cron jobs, whatever you want)
- Hosting documentation if you want it accessible
- Managing logs and metadata

It's the raw engine. You get full control, but you also have to build the surrounding infrastructure yourself.

### dbt Cloud

SaaS product that runs dbt Core under the hood. It gives you:

- A web-based IDE for writing transformations (or you can use a Cloud CLI if you prefer local development)
- Environment management — dev/staging/prod, all handled for you
- Built-in orchestration (job scheduling, triggers, dependencies)
- Hosted documentation (automatically generated and served)
- Logging and observability
- APIs for administration and metadata access
- A semantic layer for metrics (if you need it)

There's a free Developer plan that works for small teams or individual learning. For anything bigger, it's a paid product.

---

## The course setup — two paths

The Zoomcamp gives you two options, and the videos will alternate between them (version A and version B):

### Option A: BigQuery + dbt Cloud (recommended)

- Data warehouse: BigQuery (assuming you set this up in previous weeks)
- dbt: dbt Cloud Developer plan (free account, web IDE)
- No local installation needed

This is the path most of the videos will follow. It's the fastest way to get started and closest to how teams actually use dbt in production.

### Option B: Postgres + dbt Core

- Data warehouse: Postgres (local or however you've got it set up)
- dbt: dbt Core installed locally
- Dev environment: your own IDE (VS Code, etc.)
- Orchestration: you'll need to handle this separately (Airflow, Prefect, whatever)

This path gives you more hands-on control but requires more setup.

---

## The project flow

By the time we get to the end of the module, here's what we'll have built:

1. Raw data sitting in the warehouse — trip data from previous weeks, plus a lookup table to demonstrate joining multiple sources
2. dbt transformations that turn that raw data into properly modeled tables following the dimensional modeling concepts from 4.1.1
3. Dashboards that consume the final output and make it useful for business stakeholders

The next videos will walk through actually setting this up and building it out step by step.