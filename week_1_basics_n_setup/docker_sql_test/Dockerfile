FROM python:latest

RUN apt-get install wget

RUN pip install pandas sqlalchemy pyarrow psycopg2

COPY ingest_data.py ingest_data.py

ENTRYPOINT [ "python","ingest_data.py" ]
