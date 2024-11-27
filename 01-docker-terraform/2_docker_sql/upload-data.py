#!/usr/bin/env python
# coding: utf-8

# In[1]:


import pandas as pd


# In[2]:


pd.__version__


# In[4]:


df = pd.read_csv('yellow_tripdata_2021-01.csv', nrows=100)


# In[11]:


df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)


# In[6]:


from sqlalchemy import create_engine


# In[9]:


engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')


# In[12]:


print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))


# In[13]:


df_iter = pd.read_csv('yellow_tripdata_2021-01.csv', iterator=True, chunksize=100000)


# In[14]:


df = next(df_iter)


# In[15]:


len(df)


# In[16]:


df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)


# In[17]:


df


# In[18]:


df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')


# In[19]:


get_ipython().run_line_magic('time', "df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')")


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

    print('inserted another chunk, took %.3f second' % (t_end - t_start))


# In[35]:


get_ipython().system('wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv')


# In[36]:


df_zones = pd.read_csv('taxi+_zone_lookup.csv')


# In[38]:


df_zones.head()


# In[42]:


df_zones.to_sql(name='zones', con=engine, if_exists='replace')


# In[ ]:




