FROM mcr.microsoft.com/devcontainers/python:3.11-bookworm

# Create a virtual environment and activate it
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Install DuckDB-specific packages into the virtual environment
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install \
    dbt-duckdb \
    requests \
    pandas \
    pyarrow

# Install DuckDB CLI, common tools, and GitHub CLI
RUN rm -f /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y unzip wget curl gnupg && \
    # DuckDB CLI
    curl -L https://github.com/duckdb/duckdb/releases/download/v1.1.3/duckdb_cli-linux-amd64.zip -o duckdb.zip && \
    unzip duckdb.zip -d /usr/local/bin && \
    rm duckdb.zip && \
    chmod +x /usr/local/bin/duckdb && \
    # GitHub CLI
    mkdir -p -m 755 /etc/apt/keyrings && \
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && apt-get install -y gh && \
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
