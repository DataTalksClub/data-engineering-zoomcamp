#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


pd.__version__


# In[3]:


df = pd.read_csv('yellow_tripdata_2021-01.csv', nrows=100)


# In[4]:


df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)


# In[5]:


from sqlalchemy import create_engine


# In[6]:


engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')


# In[7]:


print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))


# In[8]:


df_iter = pd.read_csv('yellow_tripdata_2021-01.csv', iterator=True, chunksize=100000)


# In[9]:


df = next(df_iter)


# In[10]:


len(df)


# In[11]:


df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)


# In[12]:


df


# In[13]:


df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')


# In[14]:


get_ipython().run_line_magic('time', "df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')")


# In[15]:


from time import time


# In[16]:


while True: 
    t_start = time()

    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    
    df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')

    t_end = time()

    print('inserted another chunk, took %.3f second' % (t_end - t_start))


# In[17]:


get_ipython().system('wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv')


# In[18]:


df_zones = pd.read_csv('taxi+_zone_lookup.csv')


# In[19]:


df_zones.head()


# In[20]:


df_zones.to_sql(name='zones', con=engine, if_exists='replace')


# In[ ]:




