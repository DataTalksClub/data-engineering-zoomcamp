FROM python:latest

RUN pip install pandas\
  pip install datetime

WORKDIR /the/workdir/path

COPY main.py main2.py

ENTRYPOINT [ "python" , "main2.py" ]
