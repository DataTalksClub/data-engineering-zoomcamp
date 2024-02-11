import os
import argparse

def main(params):
    user = 'root'
    password = 'root'
    host = 'localhost' 
    port = '5432' 
    db = 'ny_taxi'
    if params.user is not None:
        user = params.user
    
    if params.password is not None:
        password = params.password

    if params.host is not None:
        host = params.host 
    
    if params.port is not None:
        port = params.port 
    
    if params.db is not None:
        db = params.db
    
    table_name = params.table_name
    url = params.url

    print('start')

    print('wget {url}')
    
    print('postgresql://{user}:{password}@{host}:{port}/{db}-{table_name}')

if __name__ == '__main__':
    print('main')
    parser = argparse.ArgumentParser(description='Ingest CSV data to Postgres')

    parser.add_argument('--user', required=False, help='user name for postgres')
    parser.add_argument('--password', required=False, help='password for postgres')
    parser.add_argument('--host', required=False, help='host for postgres')
    parser.add_argument('--port', required=False, help='port for postgres')
    parser.add_argument('--db', required=False, help='database name for postgres')
    parser.add_argument('--table_name', required=True, help='name of the table where we will write the results to')
    parser.add_argument('--url', required=True, help='url of the csv file')

    args = parser.parse_args()

    main(args)