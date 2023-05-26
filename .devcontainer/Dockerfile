# Start with the base Ubuntu image
FROM ubuntu:20.04

# Add label maintainer
LABEL maintainer="gluonhiggs"

# Specify the path of the workspace
WORKDIR /workspaces

# Install software-properties-common, and then Python 3.10
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 python3.10-distutils python3.10-venv python3.10-dev && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 1 && \
    apt-get install -y curl 

# Install pip
RUN curl https://bootstrap.pypa.io/get-pip.py | python3 && \
    pip3 install --upgrade pip

# Set an environment variable
ENV REFRESHED_AT 2023-05-26

# Copy all files in the current directory on the host machine
# to the /workspaces/ directory in the Docker image
COPY . /workspaces/

# Install Python packages specified in requirements.txt
RUN pip3 install -r ./.devcontainer/requirements.txt

# Make port 8888 available to the world outside this container
EXPOSE 8888
