FROM python:3.9-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir \
    requests \
    pandas \
    sqlalchemy \
    pyarrow \
    psycopg2-binary

# Copy your script into the container
COPY uploadCSV.py /app/uploadCSV.py

# Set the working directory
WORKDIR /app

# Define default command
ENTRYPOINT ["python", "uploadCSV.py"]
