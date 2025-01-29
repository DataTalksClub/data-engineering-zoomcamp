FROM python:3.9-slim
RUN apt-get update && apt-get install -y gcc libssl-dev python3-dev
RUN pip install pandas fastparquet pyarrow requests  # Add requests for downloading files
RUN pip install --upgrade pip setuptools wheel

