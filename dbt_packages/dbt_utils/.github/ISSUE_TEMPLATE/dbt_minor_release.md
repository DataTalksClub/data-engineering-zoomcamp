---
name: dbt Minor Release Follow-Up
about: A checklist of tasks to complete after a minor release is made to dbt
title: 'dbt Minor Release Follow up for dbt v0.x.0'
labels:
assignees: ''
---

<!---
This template is to be used once a new dbt minor release is available on pypi.
In the future, we will consider doing pre-releases.
-->

First, check if this is a breaking change
- [ ] Increase the upper bound of the `require-dbt-version` config in the `dbt_project.yml`
- [ ] Increase the upper bound of the dbt version in `run_test.sh`
- [ ] Create a PR against the `master` branch to see if tests pass

If test pass, this is _not_ a breaking change. You should:
- [ ] Merge into `master`
- [ ] Create a patch release

If tests fail, this _is_ a breaking change. You'll need to create a minor release:
- [ ] Change the PR base to be against the next `dev` branch.
- [ ] Increase the lower bound to the current dbt minor version in both the `dbt_project.yml` and `run_test.sh` files
- [ ] Fix any errors
- [ ] Merge `dev` into `master`
- [ ] Create a minor release
- [ ] Once the release is available on hub, [create a new issue](https://github.com/fishtown-analytics/dbt-utils/issues/new/choose) using the "dbt-utils Minor Release Checklist" template
