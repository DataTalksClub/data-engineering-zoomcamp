# %%
import pandas as pd

# %% [markdown]
# ```bash
# pip install sqlalchemy psycopg2-binary
# ```

# %%
from sqlalchemy import create_engine

# %%
engine = create_engine("postgresql://root:root@localhost:5432/ny_taxi")

# %%
engine.connect()

# %%
query = """
SELECT 1 as number;
"""

pd.read_sql(query, con=engine)

# %%
query = """
SELECT *
FROM pg_catalog.pg_tables
WHERE schemaname != 'pg_catalog' AND 
    schemaname != 'information_schema';
"""

pd.read_sql(query, con=engine)

# %%
df = pd.read_parquet("data/green_tripdata_2019-09.parquet")
zones = pd.read_csv("data/zone_lookup.csv")
df.columns = [col.lower() for col in df.columns]
zones.columns = [col.lower() for col in zones.columns]

# %%
df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

# %%
## GENERATING DDL (DATA DEFINITION LANGUAGE) FOR OUR DF
pd.io.sql.get_schema(df, name="green_taxi_data")

# %%
df.to_sql(name="green_taxi_trips_sept_2019", con=engine, index=False)
zones.to_sql(name="zones", con=engine, index=False)

# %%


# %%
query = """
SELECT * FROM green_tripdata_trip LIMIT 10
"""

pd.read_sql(query, con=engine)

# %% [markdown]
# ```sql
# SELECT *
# FROM pg_catalog.pg_tables
# WHERE schemaname != 'pg_catalog' AND
#     schemaname != 'information_schema';
# ```
#
# Source: https://www.postgresqltutorial.com/postgresql-show-tables/

# %%
