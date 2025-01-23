from time import time

import pandas as pd
from sqlalchemy import create_engine
from settings import Settings

settings = Settings()


def main():
    user = settings.db_username
    password = settings.db_username
    host = settings.db_host
    port = settings.db_port
    db = settings.db_name
    table_name_1 = settings.table_trip_name
    table_name_2 = settings.table_zones_name
    csv1 = './data/green_tripdata_2019-10.csv'
    csv2 = './data/taxi_zone_lookup.csv'

    # create db connection
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')

    # trips
    print('inserting trips to database')
    df_iter = pd.read_csv(csv1, iterator=True, chunksize=100000)
    df = next(df_iter)
    df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
    df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
    df.head(n=0).to_sql(name=table_name_1, con=engine, if_exists='replace')
    df.to_sql(name=table_name_1, con=engine, if_exists='append')
    for chunk in df_iter:
        t_start = time()
        df = chunk
        df.lpep_pickup_datetime = pd.to_datetime(df.lpep_pickup_datetime)
        df.lpep_dropoff_datetime = pd.to_datetime(df.lpep_dropoff_datetime)
        df.to_sql(name=table_name_1, con=engine, if_exists='append')
        t_end = time()
        print('inserted another chunk, took %.3f second' % (t_end - t_start))
    print('finished inserting trips to database')

    # zones
    print('inserting zones to database')
    df = pd.read_csv(csv2)
    df.to_sql(name=table_name_2, con=engine, if_exists='append')
    print('finished inserting zones to database')


if __name__ == '__main__':
    main()


