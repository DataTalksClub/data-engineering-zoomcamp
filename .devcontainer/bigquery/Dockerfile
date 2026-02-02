FROM python:3.11-slim-bookworm

# Install sudo and create vscode user for compatibility with devcontainers
RUN apt-get update && apt-get install -y sudo && \
    useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Create a virtual environment and activate it
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install BigQuery-specific packages into the virtual environment
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install \
    dbt-bigquery \
    requests \
    pandas \
    pyarrow \
    google-cloud-storage

# Install common tools, GitHub CLI, and Google Cloud CLI
RUN rm -f /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y wget curl gnupg && \
    # GitHub CLI
    mkdir -p -m 755 /etc/apt/keyrings && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y gh && \
    # Google Cloud CLI
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update -y && apt-get install google-cloud-cli -y && \
    # Cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy devcontainer config to image for reliable setup
COPY . /opt/devcontainer/

# Ensure the virtual environment is automatically activated in every new shell
RUN echo "source $VIRTUAL_ENV/bin/activate" >> /home/vscode/.bashrc

# Create the homework directory and set permissions
RUN mkdir -p /home/vscode/homework && \
    chown -R vscode:vscode /home/vscode/homework

# Fix permissions for the virtual environment and scripts
RUN chown -R vscode:vscode /opt/venv /opt/devcontainer && \
    chmod -R +x /opt/devcontainer/scripts/*.sh
