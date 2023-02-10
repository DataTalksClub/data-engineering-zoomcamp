FROM prefecthq/prefect:2.7.7-python3.10

WORKDIR app/

COPY docker-requirements.txt .

RUN pip install -r docker-requirements.txt

COPY *.py /opt/prefect/flows/
COPY data /opt/prefect/data
