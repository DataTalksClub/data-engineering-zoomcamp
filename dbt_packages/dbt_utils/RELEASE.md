# dbt-utils releases

## When do we release?
There's a few scenarios that might prompt a release:

| Scenario                                   | Release type |
|--------------------------------------------|--------------|
| New functionality¹                         | minor        |
| Breaking changes to existing macros        | minor        |
| Fixes to existing macros                   | patch        |
| dbt minor release with no breaking changes | patch        |
| dbt minor release with breaking changes    | minor        |

¹New macros were previously considered patch releases — we have brought them up to minor releases to make versioning for dependencies clearer.

## Branching strategy

At any point, there should be two long-lived branches:
- `master` (default): This reflects the most recent release of dbt-utils
- `dev/0.x.0`: This reflects the next minor release, where `x` will be replaced with the minor version number

The `dev/0.x.0` branch should be merged into `master` branch when new releases are created.

## Process for minor releases
e.g. for releasing `0.x.0`
1. Create the PR to merge `dev/0.x.0` into `master`. Also update the `Changelog` as part of this PR, and merge it.
2. Create the GitHub release from the `master` branch.
3. Delete the `dev/0.x.0` branch, and create a new branch `dev/0.x+1.0` from `master`, adding branch protection to it.
4. [Create a new issue](https://github.com/fishtown-analytics/dbt-utils/issues/new/choose) from the "dbt-utils Minor Release Follow-Up" template to also update any dependencies.

## Process for patch releases
1. Create the release.
2. Then rebase the current `dev/0.x.0` branch on top of the `master` branch so that any fixes will be included in the next minor release.

No dependent packages need to be updated for patch releases (e.g. codegen, audit-helper)
