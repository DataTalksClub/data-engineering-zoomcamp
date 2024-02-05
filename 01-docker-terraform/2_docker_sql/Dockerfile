FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data_v2.py ingest_data_v2.py 

ENTRYPOINT [ "python", "ingest_data_v2.py" ]