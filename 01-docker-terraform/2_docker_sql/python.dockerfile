FROM python:latest

RUN pip install pandas sqlalchemy psycopg2 pyarrow

ENTRYPOINT ["bash"]