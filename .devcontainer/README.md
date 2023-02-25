# Devcontainer for DataTalksClub Data Engineering Zoomcamp
This devcontainer sets up a development environment for this class. This can be used with both VS Code and GitHub Codespaces.

## Getting Started
To continue, make sure you have [Visual Studio Code](https://code.visualstudio.com/) and [Docker Desktop](https://www.docker.com/products/docker-desktop/) installed OR use [GitHub Codespaces](https://github.com/features/codespaces).

**Option 1: Local VS Code**

1. Clone the repo and connect to it in VS Code:

```bash
$ cd your/desired/repo/location
$ git clone https://github.com/DataTalksClub/data-engineering-zoomcamp.git
```

1. Download the [`Dev Containers`](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension from the VS Code marketplace. Full docs on devcontainers [here](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

2. Press Cmd + Shift + P (Mac) or Ctrl + Shift + P (Windows) to open the Command Pallette. Type in `Dev Containers: Open Folder in Container` and select the repo directory
   
3. Wait for the container to build and the dependencies to install
   
**Option 2: GitHub Codespaces**

1. Fork this repo
   
2. From the repo page in GitHub, select the green `<> Code` button and choose Codespaces
   
3. Click `Create Codespace on Main`, or checkout a branch if you prefer
   
4. Wait for the container to build and the dependencies to install
   
5. Start developing!


## Included Tools and Languages:

* `Python 3.9`
  - `Pandas`
  - `SQLAlchemy`
  - `PySpark`
  - `PyArrow`
  - `Polars`
  - `Prefect 2.7.7` and all required Python dependencies
  - `confluent-kafka`
* `Google Cloud SDK`
* `dbt-core`
  - `dbt-postgres`
  - `dbt-bigquery`
* `Terraform`
* `Jupyter Notebooks for VS Code`
* `Docker`
* `Spark`
* `JDK` version 11
* [`Oh-My-Posh Powershell themes`](https://github.com/JanDeDobbeleer/oh-my-posh)
* Popular VS Code themes (GitHub, Atom One, Material Icons etc.)

## Customization
Feel free to modify the `Dockerfile`, `devcontainer.json` or `requirements.txt` file to include any other tools or packages that you need for your development environment. In the Dockerfile, you can customize the `POSH_THEME` environment variable with a theme of your choosing from [here](https://ohmyposh.dev/docs/themes)
