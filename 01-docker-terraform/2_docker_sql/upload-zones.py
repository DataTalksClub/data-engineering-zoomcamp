#!/usr/bin/env python
# coding: utf-8

# In[2]:


import pandas as pd


# In[3]:


pd.__version__


# In[5]:


df = pd.read_csv('taxi+_zone_lookup.csv', nrows=100)


from sqlalchemy import create_engine


# In[41]:


engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')


# In[20]:


print(pd.io.sql.get_schema(df, name='zones', con=engine))


# In[21]:


df_iter = pd.read_csv('taxi+_zone_lookup.csv', iterator=True, chunksize=100000)



# In[32]:


from time import time


# In[33]:


while True: 
    t_start = time()

    df = next(df_iter)


    df.to_sql(name='zones', con=engine, if_exists='append')

    t_end = time()

    print('inserted another chunk, took %.3f second' % (t_end - t_start))




