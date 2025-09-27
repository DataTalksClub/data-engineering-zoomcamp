import pandas as pd

from sqlalchemy import create_engine

df = pd.read_csv('yellow_tripdata_2021-01.csv', nrows=100)

df

pd.io.sql.get_schema(df, name="yellow_taxi_data")
print(pd.io.sql.get_schema(df, name="yellow_taxi_data"))
pd.to_datetime(df.tpep_pickup_datetime)
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
engine.connect()
print(pd.io.sql.get_schema(df, name="yellow_taxi_data", con=engine))
df_iter = pd.read_csv('yellow_tripdata_2021-01.csv', iterator=True, chunksize=100000)
df_iter
df = next(df_iter)
df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
df
df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')


# In[ ]:





# In[19]:


get_ipython().run_line_magic('time', "df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')")


# In[28]:


while True:


# In[20]:


from time import time


# In[21]:


while True:
    t_start = time()
    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')
    t_end = time()
    print('inserted another chunk..., took %.3f second' % (t_end - t_start))


# In[ ]:




