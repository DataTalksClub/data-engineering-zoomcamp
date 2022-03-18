FROM python:3.9.1

RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY ingest_data_cli.py ingest_data_cli.py 

ENTRYPOINT [ "python", "ingest_data_cli.py" ]