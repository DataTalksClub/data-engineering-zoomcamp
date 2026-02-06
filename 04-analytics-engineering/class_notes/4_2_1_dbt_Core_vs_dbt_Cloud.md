# DE Zoomcamp 4.2.1 — dbt Core vs dbt Cloud

> 📄 Official feature comparison: [dbt Core vs dbt Cloud](https://www.getdbt.com/product/dbt-core-vs-dbt-cloud)

## dbt Core
- Born in **2016** as a fully **open-source, command-line tool**
- 100% free, runs locally on your own machine
- All code is available on GitHub (can fork, modify, etc.)

## dbt Cloud
- Introduced **two years after dbt Core** (~2018) by dbt Labs (originally called Fishtown Analytics)
- Sold as a **paid SaaS platform** — no need to manage infrastructure yourself
- Handles the heavy lifting:
  - Hosting dbt documentation
  - Orchestration
  - Environment setup
  - Backups of dbt artifacts (e.g. for Slim CI)
- Comes with **collaboration and security features** useful for teams/companies

## How They Were Used Together (Hybrid Approach)
- Common pattern: more technical users worked with dbt Core; less technical users used dbt Cloud
- The two were designed to be **compatible** — e.g. developers could work locally with dbt Core while production runs were executed through dbt Cloud
- dbt Labs published an article in **October 2024** outlining how both products were meant to coexist side by side → [How we think about dbt Core and dbt Cloud](https://www.getdbt.com/blog/how-we-think-about-dbt-core-and-dbt-cloud)

## dbt Fusion — The Future
- In **May 2025**, dbt Labs announced a **full rewrite of the code base** using a new engine called **Fusion**
- Key improvements:
  - **Faster compilation** of dbt code (up to 30x faster in some cases)
  - **Better developer experience** — catches many errors *before* running/building, saving time and money
- dbt Core will continue to be maintained, but **Fusion is the future direction** for both Core and Cloud

### Fusion Limitations
- **Not supported by all adapters** — as of early 2026, Fusion supports major adapters like Snowflake, Databricks, Postgres (and derivatives), BigQuery, and Redshift
- Notably **does not support DuckDB** (yet) or many community-maintained adapters
- If you use a less common adapter, dbt Fusion and the newest versions of dbt Cloud may not work for you
- Adapter support is being actively expanded — check the official docs for the current list

> 📄 Fusion upgrade guide: [Upgrading to the dbt Fusion engine](https://docs.getdbt.com/docs/dbt-versions/core-upgrade/upgrading-to-fusion)  
> 📄 Full adapter support list: [Supported features](https://docs.getdbt.com/docs/fusion/supported-features)

## New Vision: Unified License
- Instead of splitting users between Core and Cloud, Fusion envisions **everyone having a dbt license**
- Users can choose to work in:
  - The **dbt Cloud IDE**, or
  - **VS Code** using the official dbt Labs extension
- Both options are backed by the same Fusion engine

## Course Decisions & Recommendations
- This course uses **DuckDB + dbt Core** (local, via VS Code) because:
  - It forces learners to understand what's actually happening under the hood
  - dbt Cloud abstracts a lot away — understanding Core first makes Cloud easier to pick up later
- If you follow along with dbt Cloud + BigQuery, the concepts transfer well
- dbt Labs' own documentation and courses are excellent resources for learning dbt Cloud specifically → [dbt Developer Hub](https://docs.getdbt.com)
- **Bottom line:** It doesn't matter much which one you learn first — especially as a consultant, you'll likely use both. Focus on the shared fundamentals.

---

*Note: This document was last updated February 2026. For the latest information on dbt Fusion and adapter support, always consult the official dbt documentation.*