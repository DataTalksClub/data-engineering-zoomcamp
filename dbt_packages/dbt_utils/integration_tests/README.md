###  Run the integration tests

To run the integration tests on your local machine, like they will get run in the CI (using CircleCI), you can do the following:

Assuming you are in the `integration_tests` folder,

```bash
make test target=[postgres|redshift|...] [models=...] [seeds=...]
```

or more specific:

```bash
make test target=postgres models=sql.test_star seeds=sql.data_star
```

or, to test against all targets:

```bash
make test-all [models=...] [seeds=...]
```

Specying `models=` and `seeds=` is optional, however _if_ you specify `seeds`, you have to specify `models` too.

Where possible, targets are being run in docker containers (this works for Postgres or in the future Spark for example). For managed services like Snowflake, BigQuery and Redshift this is not possible, hence your own configuration for these services has to be provided in the appropriate env files in `integration_tests/.env/[TARGET].env`

### Creating a new integration test

This directory contains an example dbt project which tests the macros in the `dbt-utils` package. An integration test typically involves making 1) a new seed file 2) a new model file 3) a schema test.

For an example integration tests, check out the tests for the `get_url_parameter` macro:

1. [Macro definition](https://github.com/fishtown-analytics/dbt-utils/blob/master/macros/web/get_url_parameter.sql)
2. [Seed file with fake data](https://github.com/fishtown-analytics/dbt-utils/blob/master/integration_tests/data/web/data_urls.csv)
3. [Model to test the macro](https://github.com/fishtown-analytics/dbt-utils/blob/master/integration_tests/models/web/test_urls.sql)
4. [A schema test to assert the macro works as expected](https://github.com/fishtown-analytics/dbt-utils/blob/master/integration_tests/models/web/schema.yml#L2)


Once you've added all of these files, you should be able to run:
```
$ dbt deps
$ dbt seed
$ dbt run --model {your_model_name}
$ dbt test --model {your_model_name}
```

If the tests all pass, then you're good to go! All tests will be run automatically when you create a PR against this repo.