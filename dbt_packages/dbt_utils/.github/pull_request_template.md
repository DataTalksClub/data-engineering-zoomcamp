This is a:
- [ ] bug fix PR with no breaking changes — please ensure the base branch is `master`
- [ ] new functionality — please ensure the base branch is the latest `dev/` branch
- [ ] a breaking change — please ensure the base branch is the latest `dev/` branch

## Description & motivation
<!---
Describe your changes, and why you're making them.
-->

## Checklist
- [ ] I have verified that these changes work locally on the following warehouses (Note: it's okay if you do not have access to all warehouses, this helps us understand what has been covered)
    - [ ] BigQuery
    - [ ] Postgres
    - [ ] Redshift
    - [ ] Snowflake
- [ ] I followed guidelines to ensure that my changes will work on "non-core" adapters by:
    - [ ] dispatching any new macro(s) so non-core adapters can also use them (e.g. [the `star()` source](https://github.com/fishtown-analytics/dbt-utils/blob/master/macros/sql/star.sql))
    - [ ] using the `limit_zero()` macro in place of the literal string: `limit 0`
    - [ ] using `dbt_utils.type_*` macros instead of explicit datatypes (e.g. `dbt_utils.type_timestamp()` instead of `TIMESTAMP`
- [ ] I have updated the README.md (if applicable)
- [ ] I have added tests & descriptions to my models (and macros if applicable)
- [ ] I have added an entry to CHANGELOG.md
