#%%
import pandas as pd
from time import time
pd.__version__
#%%
df = pd.read_csv('https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz', nrows=100)
#%%
# Преобразуйте столбцы с датами и временем в формат datetime
df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])
df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])
#%%
from sqlalchemy import create_engine
#%%
engine = create_engine('postgresql://root:root@localhost:5432/my_taxi')
#%%
print(pd.io.sql.get_schema(df, name='green_taxi_data', con=engine))
#%%
df_iter = pd.read_csv('https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz', iterator=True, chunksize=100000)
df = next(df_iter)
len(df)
#%%
# Преобразуйте столбцы с датами и временем в формат datetime
df['lpep_pickup_datetime'] = pd.to_datetime(df['lpep_pickup_datetime'])
df['lpep_dropoff_datetime'] = pd.to_datetime(df['lpep_dropoff_datetime'])
#%%
df.info()
#%%
df.head(n=0).to_sql(name='green_taxi_data', con=engine, if_exists='replace')
#%%
%time df.to_sql(name='green_taxi_data', con=engine, if_exists='append')
#%%
while True:
    t_start = time()

    df = next(df_iter)

    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)

    df.to_sql(name='green_taxi_data', con=engine, if_exists='append')

    t_end = time()

    print('inserted another chunk, took %.3f second' % (t_end - t_start))
#%%
df_zones = pd.read_csv('https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv')
#%%
df_zones.head()
#%%
df_zones.to_sql(name='zones', con=engine, if_exists='replace')
#%%
# Сколько всего поездок на такси было совершено 18 сентября 2019 года?
#%%
query = """
SELECT COUNT(*) FROM green_taxi_data
WHERE DATE(lpep_pickup_datetime) = '2019-09-18'
AND DATE(lpep_dropoff_datetime) = '2019-09-18';
"""

pd.read_sql(query, con=engine)
#%%
# В какой день была наибольшая дальность поездки. Используйте время посадки для своих расчетов.
#%%
query = """
SELECT
DATE(lpep_pickup_datetime) AS pickup_day,
MAX(trip_distance) AS total_distance
FROM
green_taxi_data
GROUP BY
DATE(lpep_pickup_datetime)
ORDER BY
total_distance DESC
LIMIT 1;
"""

pd.read_sql(query, con=engine)
#%%
# Вопрос 5. Количество пассажиров 
# Учитывайте lpep_pickup_datetime в «2019-09-18», и игнорирование «Город» 'Unknown'.
# В каких трех округах сумма total_amount превышала 50 000?
#%%
query = """
SELECT 
	zpu."Borough",
	SUM(t.total_amount)
FROM 
	green_taxi_data t JOIN zones zpu 
		ON t."PULocationID"= zpu."LocationID"
WHERE 
	CAST(lpep_pickup_datetime AS DATE)='2019-09-18' AND
	zpu."Borough"!='Unknown'
GROUP BY
	zpu."Borough"
HAVING
	SUM(t.total_amount)>50000;
"""

pd.read_sql(query, con=engine)
#%%
# Вопрос 6. Самые крупные чаевые
# Для пассажиров, забранных в сентябре 2019 года в зоне под названием Астория,
# в какой зоне высадки были самые большие чаевые? Нам нужно имя зоны, а не идентификатор.
# Примечание: это не опечатка, это чаевые, а не трип.
#%%
query = """
SELECT 
	zdo."Zone",
	MAX(t.tip_amount)
FROM 
	green_taxi_data t JOIN zones zpu 
		ON t."PULocationID"= zpu."LocationID"
	JOIN zones zdo ON t."DOLocationID"= zdo."LocationID"
WHERE 
	TO_CHAR(lpep_pickup_datetime, 'YYYY')='2019' AND
	TO_CHAR(lpep_pickup_datetime, 'MM')='09' AND
	zpu."Zone"='Astoria'
GROUP BY
	zdo."Zone"
ORDER BY 
	MAX(t.tip_amount) DESC
LIMIT 3;
"""

pd.read_sql(query, con=engine)
#%%

# Выберите поездки, которые начались и закончились 18 сентября 2019 года
trips_on_sept_18 = df[(df['lpep_pickup_datetime'].dt.date == pd.to_datetime('2019-09-18').date()) & (df['lpep_dropoff_datetime'].dt.date == pd.to_datetime('2019-09-18').date())]

# Подсчитайте количество таких поездок
num_trips = len(trips_on_sept_18)

num_trips

#%% md
# В какой день была наибольшая дальность поездки. Используйте время посадки для своих расчетов.
#%%
max_trip_day = df['trip_distance'].idxmax()
df.loc[max_trip_day, 'lpep_pickup_datetime'].date()
#%%
