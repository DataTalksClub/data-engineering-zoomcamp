import os
import pandas as pd
from sqlalchemy import create_engine

# 1. Download setup
url = "https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"
csv_name = "green_tripdata_2019-09.csv.gz"

print("Cleaning old files and downloading dataset...")
os.system(f"rm -f {csv_name}")
os.system(f"curl -L -o {csv_name} {url}")

# 2. Database connection
engine = create_engine('postgresql://root:rootpassword@localhost:5432/ny_taxi')

# 3. Read iterator
df_iter = pd.read_csv(csv_name, iterator=True, chunksize=100000, compression='gzip')

# --- THIS IS THE MISSING PART ---
# Get first chunk to create header/table schema
df = next(df_iter)

# Parse datetime columns if needed
df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

# Create the table schema (replace existing if any)
df.head(n=0).to_sql(name='green_taxi_data', con=engine, if_exists='replace')

# Insert the first chunk
df.to_sql(name='green_taxi_data', con=engine, if_exists='append')
print("Inserted first chunk...")

# Loop through remaining chunks
for chunk in df_iter:
    chunk.lpep_pickup_datetime = pd.to_datetime(chunk.lpep_pickup_datetime)
    chunk.lpep_dropoff_datetime = pd.to_datetime(chunk.lpep_dropoff_datetime)
    
    chunk.to_sql(name='green_taxi_data', con=engine, if_exists='append')
    print("Inserted another chunk...")

print("Finished inserting all data!")