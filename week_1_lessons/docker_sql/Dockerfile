FROM python:3.9.1

RUN pip install pandas



WORKDIR /app
#this sets the working directory within the docker image

COPY pipeline.py pipeline.py
#This tells docker while files from the local diretory to copy over and the second word gives the files a name


ENTRYPOINT ["python","pipeline.py"]
#This tells the file what to load up and run when the image is run. This means run python and then have python run our file

