FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
RUN wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz
RUN gzip -d green_tripdata_2019-09.csv.gz
RUN wget https://s3.amazonaws.com/nyc-tlc/misc/taxi+_zone_lookup.csv