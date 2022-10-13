---
name: dbt-utils Minor Release Follow-up
about: A checklist of tasks to complete after making a dbt-utils minor release
title: 'dbt Minor Release Follow up for dbt-utils v0.x.0'
labels:
assignees: ''
---

<!---
This template is to be used once a new dbt-utils release is available on hub.
In the future, we will consider automating this.
-->

## Process for each dependent package
First, check if this is a breaking change
- [ ] Increase the upper bound of the `dbt-utils` `version:` config in the `packages.yml` of the dependent package.
- [ ] Push to a new branch to see if tests pass, or test locally.

If this is _not_ a breaking change:
- [ ] Create a patch release

If this _is_ a breaking change:
- [ ] Fix any breaking changes
- [ ] Increase the lower bound to the current dbt-utils minor version
- [ ] Create a minor release for the package

## Checklist of dependent packages
| Package                                                                      | PR     | Release     |
|------------------------------------------------------------------------------|--------|-------------|
| [audit-helper](https://github.com/fishtown-analytics/dbt-audit-helper)       | [PR]() | [Release]() |
| [codegen](https://github.com/fishtown-analytics/dbt-codegen)                 | [PR]() | [Release]() |
| [redshift](https://github.com/fishtown-analytics/redshift)                   | [PR]() | [Release]() |
| [event-logging](https://github.com/fishtown-analytics/dbt-event-logging)     | [PR]() | [Release]() |
| [snowplow](https://github.com/fishtown-analytics/snowplow)                   | [PR]() | [Release]() |
| [external-tables](https://github.com/fishtown-analytics/dbt-external-tables) | [PR]() | [Release]() |
| [segment](https://github.com/fishtown-analytics/segment)                     | [PR]() | [Release]() |
| [facebook-ads](https://github.com/fishtown-analytics/facebook-ads)           | [PR]() | [Release]() |
| [stitch-utils](https://github.com/fishtown-analytics/stitch-utils)           | [PR]() | [Release]() |
