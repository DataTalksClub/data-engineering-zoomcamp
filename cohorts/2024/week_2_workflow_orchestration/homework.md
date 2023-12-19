## Week 2 Homework

We'll be working with a _customers_ dataset. Use the following url to download the dataset:

`https://github.com/datablist/sample-csv-files/raw/main/files/customers/customers-500000.zip?raw=True`

The following are steps to constructing an ETL pipeline using Mage that were covered in the course. 

1. Create a new pipeline, call it `customers_etl`
2. Add a data loader block and use Pandas to read data directly from the url above (hint: the file is compressed)
    a. Add an assertion that checks the number of rows in the dataset is 500,000.
    b. `BONUS`: Add an assertion that ensures _all_ `Customer IDs` have the same length.
3. Add a transformer block and perform the following:
    a. Drop the `Index` column.
    b. Rename all of the columns to lowercase, replace spaces with underscores. BONUS: do this dynamically.
    c. Create a `protocol` column that extracts the protocol from the `website` column.
    d. Drop customers with unsecure websites (i.e. `http` protocol).
4. Using a Postgres data exporter (SQL or Python), write the dataset to a table called `customers` in a schema `mage`. Replace the table if it already exists.
    a. `BONUS`: Write your data as Parquet files to a bucket in GCP, partioned by `subscription_date`.
5. Schedule your pipeline to run daily at 5AM UTC.
6. Join the [Mage Slack](https://mage.ai/chat) channel and say hi 👋