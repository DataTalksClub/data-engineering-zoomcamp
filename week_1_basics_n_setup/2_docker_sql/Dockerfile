FROM python:3.9.1

RUN apt-get install wget

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
COPY ingest_data.py ingest_data.py 

ENTRYPOINT [ "python", "ingest_data.py" ]