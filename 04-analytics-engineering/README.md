# Week 4: Analytics Engineering 
Goal: Transforming the data loaded in DWH into Analytical Views developing a [dbt project](taxi_rides_ny/README.md).

### Prerequisites
By this stage of the course you should have already: 

- A running warehouse (BigQuery or postgres) 
- A set of running pipelines ingesting the project dataset (week 3 completed)
- The following datasets ingested from the course [Datasets list](https://github.com/DataTalksClub/nyc-tlc-data/): 
  * Yellow taxi data - Years 2019 and 2020
  * Green taxi data - Years 2019 and 2020 
  * fhv data - Year 2019. 

> [!NOTE]  
> * We have two quick hack to load that data quicker, follow [this video](https://www.youtube.com/watch?v=Mork172sK_c&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs) for option 1 or check instructions in [week3/extras](../03-data-warehouse/extras) for option 2

## Setting up your environment 
  
> [!NOTE]  
>  the *cloud* setup is the preferred option.
>
> the *local* setup does not require a cloud database.

| Alternative A | Alternative B |
---|---|
| Setting up dbt for using BigQuery (cloud) | Setting up dbt for using Postgres locally  |
|- Open a free developer dbt cloud account following [this link](https://www.getdbt.com/signup/)|- Open a free developer dbt cloud account following [this link](https://www.getdbt.com/signup/)<br><br> |
| - [Following these instructions to connect to your BigQuery instance]([https://docs.getdbt.com/docs/dbt-cloud/cloud-configuring-dbt-cloud/cloud-setting-up-bigquery-oauth](https://docs.getdbt.com/guides/bigquery?step=4)) | - follow the [official dbt documentation]([https://docs.getdbt.com/dbt-cli/installation](https://docs.getdbt.com/docs/core/installation-overview)) or <br>- follow the [dbt core with BigQuery on Docker](docker_setup/README.md) guide to setup dbt locally on docker or <br>- use a docker image from oficial [Install with Docker](https://docs.getdbt.com/docs/core/docker-install). |
|- More detailed instructions in [dbt_cloud_setup.md](dbt_cloud_setup.md)  | - You will need to install the latest version with the BigQuery adapter (dbt-bigquery).|
| | - You will need to install the latest version with the postgres adapter (dbt-postgres).|
| | After local installation you will have to set up the connection to PG in the `profiles.yml`, you can find the templates [here](https://docs.getdbt.com/docs/core/connect-data-platform/postgres-setup) |

### --- EllaNotes ---

#### From BigQuery public dataset

* BQ has 
  * fhv data from 2015-2017
  * green data from 2014-2023
  * yellow data from 2011-2023
* project-id: `nyc-rides-ella`
* dataset schema: `trips_data_all`
  * multi region (US)
* table names: `yellow_tripdata`, `green_tripdata`, `fhv_tripdata`
  * native table
  ```sql
  CREATE TABLE AS {project-id}.{schema}.{yellow_tripdata} as
  SELECT FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2019`; 
  INSERT INTO AS {project-id}.{schema}.{yellow_tripdata}
  SELECT FROM `bigquery-public-data.new_york_taxi_trips.tlc_yellow_trips_2020`;

  CREATE TABLE AS {project-id}.{schema}.{green_tripdata} as
  SELECT FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2019`;
  INSERT INTO AS {project-id}.{schema}.{green_tripdata}
  SELECT FROM `bigquery-public-data.new_york_taxi_trips.tlc_green_trips_2020`;
  ```
* Need to do cleanup with Vic's `hack-load-data.sql` from [this page](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/taxi_rides_ny/analyses/hack-load-data.sql), because the BigQuery's schema and our DTC source's schema is different. Follow DTC's schema.
* fhv data has to be loaded from elsewhere since BQQ do not have it

#### From DTC `nyc-tlc-data` repo

* https://github.com/DataTalksClub/nyc-tlc-data/tree/main
* using tweaked `web_to_gcs.py`
* brute force TIMESTAMP conversion, and lots of repeats
* disadvantages:
  * slow
  * `.csv.gz` files are downloaded to local filesystem

#### Via Mage


#### Via dlt

## Content

### Introduction to analytics engineering

* What is analytics engineering?
* ETL vs ELT 
* Data modeling concepts (fact and dim tables)

[![](https://markdown-videos-api.jorgenkh.no/youtube/uF76d5EmdtU)](https://youtu.be/uF76d5EmdtU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=40)

### What is dbt? 

* Introduction to dbt 

[![](https://markdown-videos-api.jorgenkh.no/youtube/4eCouvVOJUw)](https://www.youtube.com/watch?v=gsKuETFJr54&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=5)

### --- EllaNotes ---

#### Definitions

ddl
: data definition language
  sql statements that manage objects - tables, views

dml
: data manipulation language
  the CRUD sql statements to SELECT, INSERT DELETE & UPDATE

- master data (like zone-lookup table) are called `seed files`
- dbt is a transformational workflow, ie manage sql and allow for code versioning of sql, testing and documentation and deploy via CI/CD
- orchestrate code from dev to deployment
- record data sources details like schema and their lineage
- follows best practices in SWE workflow
  - modularity, DRY, testable and documented tests
- 2 main ways: cloud (web IDE/CLI, SaaS, depends on core) and core (local, open source)
- because the free Dev account only allows for one project per account, need to do lessons and homework within this same project


## Starting a dbt project

| Alternative A  | Alternative B   |
|-----------------------------|--------------------------------|
| Using BigQuery + dbt cloud | Using Postgres + dbt core (locally) |
| - Starting a new project with dbt init (dbt cloud and core)<br>- dbt cloud setup<br>- project.yml<br><br> | - Starting a new project with dbt init (dbt cloud and core)<br>- dbt core local setup<br>- profiles.yml<br>- project.yml                                  |
| [![](https://markdown-videos-api.jorgenkh.no/youtube/iMxh6s_wL4Q)](https://www.youtube.com/watch?v=J0XCDyKiU64&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=4) | [![](https://markdown-videos-api.jorgenkh.no/youtube/1HmL63e-vRs)](https://youtu.be/1HmL63e-vRs&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=43) |

### --- EllaNotes ---

Setting up your new project on dbt cloud's IDE.

1.  video: 4.2.1 - Start Your dbt Project BigQuery and dbt Cloud (Alternative A)
1.  `model` in dbt refers to SQL queries in dbt code yml format
1. sign up on dbt website for a free developer account, the company name is the Team-name (limited to 1 per dev account); cannot be changed after profile created. Not explained!
    - Vic's is 'analytics-engineering-workshop'
    - mine is 'a company'
1.  setup your project like so
   ![](../images/dbt-project-settings.png)
1.  to start our dbt project, first create a `staging` folder under `model` folder
   ![](../images/dbt-start-define-source.png)
1.  and then create `schema.yml` in this folder
   ![](../images/dbt-start-schema-file.png)
    - change the `database` entry to the `dataset` value from your BigQuery instance and mine is `nyc-rides-ella`, which for me I've set it to be the same as my `project-id` (maybe I shouldn't have done this? well hindsight 20/20 and all that)



### dbt models

* Anatomy of a dbt model: written code vs compiled Sources
* Materialisations: table, view, incremental, ephemeral  
* Seeds, sources and ref  
* Jinja and Macros 
* Packages 
* Variables

[![](https://markdown-videos-api.jorgenkh.no/youtube/UVI30Vxzd6c)](https://www.youtube.com/watch?v=ueVy2N54lyc&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=3)

> [!NOTE]  
> *This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice*

> [!TIP] 
>* If you recieve an error stating "Permission denied while globbing file pattern." when attempting to run `fact_trips.sql` this video may be helpful in resolving the issue
>
>[![](https://markdown-videos-api.jorgenkh.no/youtube/kL3ZVNL9Y4A)](https://youtu.be/kL3ZVNL9Y4A&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=34)

### --- EllaNotes ---

1.  video: 4.3.1 - Build the First dbt Models
1.  master data aka seeds aka lookups ie our zones data
1.  fact tables (), dimensional tables (sources: trip data)
1.  sql scripts are called `models` in dbt
1.  dbt generates the ddl and dml for us when we `compile` our model code with `dbt build`, and `dbt run` then uses this compiled code
1.  materialization types: ephemeral, view, table, incremental (drop & re-create, or insert new data in same table)
1.  dependencies coded into the model and follows from dev to staging to production, and also in version control
1.  input `tables` names of `green_tripdata` and `yellow_tripdata`
1.  once you typed in the tables names, dbt would prompt you to `generate model`, click on this and new tab pops open with model `stg_staging__green_tripdata.sql` in another `staging` subfolder
1.  `Save` this yml file and move it one level up, we don't want it nested `/model/staging/staging` but just `model/staging`
1.  also remove the folder after you've moved the yml file
1.  and finally rename the yml file to remove that extra `staging` so final filename is `taxi_rides_ny/models/staging/stg_green_tripdata.sql`
1.  test `dbt build` in the console CLI and it should fail as it is starting from the `example` models subfolder, and due to this failed step, all the subsequent steps are skipped because these are dependencies
1.  we're going to remove these `example` models and tests, simply by removing the folder under `models` and continue 
1.  macros: uses templating language jinja
    - is applicable project-wide
    - akin to utilities/helper functions & .env/config code in Python
    - it's common code that can be used repeatedly in all our models throughout this project
    - create `get_payment_type_description.sql` under the `macros` folder.
    - copy contents from [](../04-analytics-engineering/taxi_rides_ny/macros/get_payment_type_description.sql)
    - and add this `{{ get_payment_type_description('payment_type') }}` in line#30 in `/models/staging/stg_green_tripdata.sql as payment_type_descripted`
    - just like Python's UDF, Macros can also be packaged and reused in other projects
    - and similarly just like [*PyPi.org*](https://pypi.org) houses packages others have made, dbt also has a *[dbt package hub](https://hub.getdbt.com/)* and we declare the import statements in a `packages.yml` file
    - the syntax is similar to how we add images in a `docker-compose.yml` file for Docker containers
1.  create `packages.yml` file in your root dbt project folder, ie in the same path as the `dbt_project.yml` file
    - once file is saved, it would trigger the install and you'll see in the command line that it's doing just that and then building 
    - if it does not gets triggered, you can manually kick off the process by doing a `dpt deps` in the CLI
    - you'll see the packages imported once it is done and new `dbt_packages` folder appear in your File Explorer tree
    - find the usage guide in the docs or gh repo
    - for our case, we want to declare at the beginning of our SELECT statement in the `stg_green_tripdata.sql` file:
    ```sql
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as tripid,
    ```
    - if you get `dbt build failed` check for commas in the 2 lines we added
    - we should be able to verify the output in our `nyc-rides-ella.dbt_ellacharmed` dataset in BigQuery
1.  after the above thorough walkthrough, we cn now just copy+paste the model code from DTC repository and learn what else Vic has added for the final output
1.  we can explicitly use the `__config` shortcut to declare the config to materialize all this as a `view`, but it is the default anyway. It could be best practice if you want to be very clear of which model would materialize a `view` or a `table` or something else
1.  the model code now checks for
    -  duplicated rows, we only bring in row data that has `rn`=1 ie no duplication
    -  exclude rows with null `vendorid`
    -  lots of CASTing of data types so the schema is consistent with yellow table
    -  renaming column names
1. `variables` can also be defined at the project level in dbt
   - we used this var in our code for this project to `limit 100` when we're jsut testing our code builds
   - so we're performing faster and cheaper queries in BQ while in dev mode
1. at this time, our lineage graph looks like this
1. now, we're going to add our zones data. Create a new folder under `/models`, call it `core`. In this folder, create a new model called `dim_zones.sql` so our zones master data lives in the path `/models/core/dim_zones.sql`
1. copy+paste the contents of the lookup table in the raw data file from [DTC repo taxi_zone_lookup.csv](04-analytics-engineering/taxi_rides_ny/seeds/taxi_zone_lookup.csv) and save it into the path `/taxi_rides_ny/seeds/taxi_zone_lookup.csv`
   -  perform a `Build` while in the csv tab, and you should be able to refresh your dataset in BQ and the seed lookup file would appear there
1. we next create the `fact_trips.sql` under `core` folder, contents is at [DTC repo fact_trips.sql](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/04-analytics-engineering/taxi_rides_ny/models/core/fact_trips.sql)
    - at this point of time, our lineage graph now looks like this
    - we also exclude any records from green and yellow trips if the zones are `Unknown`
1. due to `ehail_fee` issues below, dropped all tables and regenerate bucket storage using Vic's [hack-load-data.sql](../04-analytics-engineering/taxi_rides_ny/analyses/hack-load-data.sql)
```
Error on building fact_trips.sql: Parquet column 'ehail_fee' has type DOUBLE which does not match the target cpp_type INT64. File: gs://<gcs bucket>/<table>/green_taxi_2019-07.parquet"
```
```
12:42:22 BigQuery adapter: Retry attempt 1 of 1 after error: BadRequest('CREATE VIEW has columns with duplicate name ehail_fee at [7:1]; reason: invalidQuery, location: query, message: CREATE VIEW has columns with duplicate name ehail_fee at [7:1]')
```
1.  make sure to do a final `dbt build` with below flags for homework, because otherwise the data is limited to first 100 records
```sql
dbt build --select +fact_trips+ --vars '{'is_test_run': 'false'}'
```  


### Testing and documenting dbt models
* Tests  
* Documentation 

[![](https://markdown-videos-api.jorgenkh.no/youtube/UishFmq1hLM)](https://www.youtube.com/watch?v=2dNJXHFCHaY&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=2)

>[!NOTE]  
> *This video is shown entirely on dbt cloud IDE but the same steps can be followed locally on the IDE of your choice*

### --- EllaNotes ---

1.  video: 4.3.2 - Testing and Documenting the Project
1.  basic tests includes
    -  unique values
    -  not null values
    -  accepted values
    -  foreign key to other tables
1.  create `dm_monthly_zone_revenue.sql` from [](../04-analytics-engineering/taxi_rides_ny/models/core/dm_monthly_zone_revenue.sql) under `/models/core/`
    ![](../images/dbt-test-dim-monthly.png.png)
    -  the `dbt.date_trunc` is referred to 'cross database macros'
1.  another package we had used uncounsciously is the `Generate model` command when we created our tables
1.  we're using the [generate_model_yaml-source](https://github.com/dbt-labs/dbt-codegen/tree/0.12.1/?tab=readme-ov-file#generate_model_yaml-source) code generator. 
    -  paste this block into a new file (it's temporary), we want the code it generates, so this code need not be saved
    -  what this does is to generate the boilerplate code to have docstrings and our models' data types
    -  we can then add some test blocks to ensure our code meet the standards of the basics test above
```
{% set models_to_generate = codegen.get_models(directory='staging', prefix='stg') %}
{{ codegen.generate_model_yaml(
    model_names = models_to_generate
) }}
```
1. can also look at `dbt_expectations` package for more tests   
1. can generate docs to be hosted on the project website to show docstrings for the project, tables or columns
1. create a `schema.yml` for tables under `core` by `compile selection` on below code block
```
{% set models_to_generate = codegen.get_models(directory='core') %}
{{ codegen.generate_model_yaml(
    model_names = models_to_generate
) }}
```
1.  then in cloud CLI, run `dbt docs generate` 
    - if locally run `dbt docs serve`

## Deployment

| Alternative A  | Alternative B   |
|-----------------------------|--------------------------------|
| Using BigQuery + dbt cloud | Using Postgres + dbt core (locally) |
| - Deployment: development environment vs production<br>- dbt cloud: scheduler, sources and hosted documentation  | - Deployment: development environment vs production<br>-  dbt cloud: scheduler, sources and hosted documentation |
| [![](https://markdown-videos-api.jorgenkh.no/youtube/rjf6yZNGX8I)](https://www.youtube.com/watch?v=V2m5C0n8Gro&list=PLaNLNpjZpzwgneiI-Gl8df8GCsPYp_6Bs&index=6) | [![](https://markdown-videos-api.jorgenkh.no/youtube/Cs9Od1pcrzM)](https://youtu.be/Cs9Od1pcrzM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=47) |

## Visualising the transformed data

:movie_camera: Google data studio Video (Now renamed to Looker studio)

[![](https://markdown-videos-api.jorgenkh.no/youtube/39nLTs74A3E)](https://youtu.be/39nLTs74A3E&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=48)

:movie_camera: Metabase Video

[![](https://markdown-videos-api.jorgenkh.no/youtube/BnLkrA7a6gM)](https://youtu.be/BnLkrA7a6gM&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=49)

 
## Advanced concepts

 * [Make a model Incremental](https://docs.getdbt.com/docs/building-a-dbt-project/building-models/configuring-incremental-models)
 * [Use of tags](https://docs.getdbt.com/reference/resource-configs/tags)
 * [Hooks](https://docs.getdbt.com/docs/building-a-dbt-project/hooks-operations)
 * [Analysis](https://docs.getdbt.com/docs/building-a-dbt-project/analyses)
 * [Snapshots](https://docs.getdbt.com/docs/building-a-dbt-project/snapshots)
 * [Exposure](https://docs.getdbt.com/docs/building-a-dbt-project/exposures)
 * [Metrics](https://docs.getdbt.com/docs/building-a-dbt-project/metrics)


## Community notes

Did you take notes? You can share them here.

* [Notes by Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/4_analytics.md)
* [Sandy's DE learning blog](https://learningdataengineering540969211.wordpress.com/2022/02/17/week-4-setting-up-dbt-cloud-with-bigquery/)
* [Notes by Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week4)
* [Marcos Torregrosa's blog (spanish)](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-4/)
* [Notes by froukje](https://github.com/froukje/de-zoomcamp/blob/main/week_4_analytics_engineering/notes/notes_week_04.md)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week4.md)
* [Setting up Prefect with dbt by Vera](https://medium.com/@verazabeida/zoomcamp-week-5-5b6a9d53a3a0)
* [Blog by Xia He-Bleinagel](https://xiahe-bleinagel.com/2023/02/week-4-data-engineering-zoomcamp-notes-analytics-engineering-and-dbt/)
* [Setting up DBT with BigQuery by Tofag](https://medium.com/@fagbuyit/setting-up-your-dbt-cloud-dej-9-d18e5b7c96ba)
* [Blog post by Dewi Oktaviani](https://medium.com/@oktavianidewi/de-zoomcamp-2023-learning-week-4-analytics-engineering-with-dbt-53f781803d3e)
* [Notes from Vincenzo Galante](https://binchentso.notion.site/Data-Talks-Club-Data-Engineering-Zoomcamp-8699af8e7ff94ec49e6f9bdec8eb69fd)
* [Notes from Balaji](https://github.com/Balajirvp/DE-Zoomcamp/blob/main/Week%204/Data%20Engineering%20Zoomcamp%20Week%204.ipynb)
* [Notes by Linda](https://github.com/inner-outer-space/de-zoomcamp-2024/blob/main/4-analytics-engineering/readme.md)
* [2024 - Videos transcript week4](https://drive.google.com/drive/folders/1V2sHWOotPEMQTdMT4IMki1fbMPTn3jOP?usp=drive)
* Add your notes here (above this line)

## Useful links
- [Slides used in the videos](https://docs.google.com/presentation/d/1xSll_jv0T8JF4rYZvLHfkJXYqUjPtThA/edit?usp=sharing&ouid=114544032874539580154&rtpof=true&sd=true)
- [Visualizing data with Metabase course](https://www.metabase.com/learn/visualization/)
- [dbt free courses](https://courses.getdbt.com/collections)
