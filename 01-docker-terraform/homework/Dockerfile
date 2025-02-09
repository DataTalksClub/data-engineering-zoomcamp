FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data.py ingest_data.py
COPY ingest_zone_data.py ingest_zone_data.py  

ENTRYPOINT [ "python"]
CMD [ "ingest_zon_data.py" ]