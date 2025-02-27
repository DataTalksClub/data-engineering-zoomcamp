# Introduction

* [![](https://markdown-videos-api.jorgenkh.no/youtube/AtRhA-NfS24)](https://www.youtube.com/watch?v=X8cEEwi8DTM)
* [Slides](https://docs.google.com/presentation/d/1974w3_zdaK7tDQJCcxHginiAuN0hRRYqXiHbDWcuVVg/edit?usp=drivesdk)
* Overview of [Architecture](https://github.com/DataTalksClub/data-engineering-zoomcamp#overview), [Technologies](https://github.com/DataTalksClub/data-engineering-zoomcamp#technologies) & [Pre-Requisites](https://github.com/DataTalksClub/data-engineering-zoomcamp#prerequisites)


We suggest watching videos in the same order as in this document.

The last video (setting up the environment) is optional, but you can check it earlier
if you have troubles setting up the environment and following along with the videos.


# Docker + Postgres

[Code](2_docker_sql)

## :movie_camera: Introduction to Docker

[![](https://markdown-videos-api.jorgenkh.no/youtube/EYNwNlOrpr0)](https://youtu.be/EYNwNlOrpr0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=4)

* Why do we need Docker
* Creating a simple "data pipeline" in Docker


## :movie_camera: Ingesting NY Taxi Data to Postgres

[![](https://markdown-videos-api.jorgenkh.no/youtube/2JM-ziJt0WI)](https://youtu.be/2JM-ziJt0WI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=5)

* Running Postgres locally with Docker
* Using `pgcli` for connecting to the database
* Exploring the NY Taxi dataset
* Ingesting the data into the database

> [!TIP]
>if you have problems with `pgcli`, check this video for an alternative way to connect to your database in jupyter notebook and pandas.
>
> [![](https://markdown-videos-api.jorgenkh.no/youtube/3IkfkTwqHx4)](https://youtu.be/3IkfkTwqHx4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=6)


## :movie_camera: Connecting pgAdmin and Postgres

[![](https://markdown-videos-api.jorgenkh.no/youtube/hCAIVe9N0ow)](https://youtu.be/hCAIVe9N0ow&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=7)

* The pgAdmin tool
* Docker networks


> [!IMPORTANT]
>The UI for PgAdmin 4 has changed, please follow the below steps for creating a server:
>
>* After login to PgAdmin, right click Servers in the left sidebar.
>* Click on Register.
>* Click on Server.
>* The remaining steps to create a server are the same as in the videos.


## :movie_camera: Putting the ingestion script into Docker

[![](https://markdown-videos-api.jorgenkh.no/youtube/B1WwATwf-vY)](https://youtu.be/B1WwATwf-vY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=8)

* Converting the Jupyter notebook to a Python script
* Parameterizing the script with argparse
* Dockerizing the ingestion script

## :movie_camera: Running Postgres and pgAdmin with Docker-Compose

[![](https://markdown-videos-api.jorgenkh.no/youtube/hKI6PkPhpa0)](https://youtu.be/hKI6PkPhpa0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=9)

* Why do we need Docker-compose
* Docker-compose YAML file
* Running multiple containers with `docker-compose up`

## :movie_camera: SQL refresher

[![](https://markdown-videos-api.jorgenkh.no/youtube/QEcps_iskgg)](https://youtu.be/QEcps_iskgg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=10)

* Adding the Zones table
* Inner joins
* Basic data quality checks
* Left, Right and Outer joins
* Group by

## :movie_camera: Optional: Docker Networking and Port Mapping

> [!TIP]
> Optional: If you have some problems with docker networking, check **Port Mapping and Networks in Docker video**.

[![](https://markdown-videos-api.jorgenkh.no/youtube/tOr4hTsHOzU)](https://youtu.be/tOr4hTsHOzU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=5)

* Docker networks
* Port forwarding to the host environment
* Communicating between containers in the network
* `.dockerignore` file

## :movie_camera: Optional: Walk-Through on WSL

> [!TIP]
> Optional: If you are willing to do the steps from "Ingesting NY Taxi Data to Postgres" till "Running Postgres and pgAdmin with Docker-Compose" with Windows Subsystem Linux please check **Docker Module Walk-Through on WSL**.

[![](https://markdown-videos-api.jorgenkh.no/youtube/Mv4zFm2AwzQ)](https://youtu.be/Mv4zFm2AwzQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=33)


# GCP

## :movie_camera: Introduction to GCP (Google Cloud Platform)

[![](https://markdown-videos-api.jorgenkh.no/youtube/18jIzE41fJ4)](https://youtu.be/18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=3)

# Terraform

[Code](1_terraform_gcp)

## :movie_camera: Introduction Terraform: Concepts and Overview, a primer

[![](https://markdown-videos-api.jorgenkh.no/youtube/s2bOYDCKl_M)](https://youtu.be/s2bOYDCKl_M&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=11)

* [Companion Notes](1_terraform_gcp)

## :movie_camera: Terraform Basics: Simple one file Terraform Deployment

[![](https://markdown-videos-api.jorgenkh.no/youtube/Y2ux7gq3Z0o)](https://youtu.be/Y2ux7gq3Z0o&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=12)

* [Companion Notes](1_terraform_gcp)

## :movie_camera: Deployment with a Variables File

[![](https://markdown-videos-api.jorgenkh.no/youtube/PBi0hHjLftk)](https://youtu.be/PBi0hHjLftk&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=13)

* [Companion Notes](1_terraform_gcp)

## Configuring terraform and GCP SDK on Windows

* [Instructions](1_terraform_gcp/windows.md)


# Environment setup

For the course you'll need:

* Python 3 (e.g. installed with Anaconda)
* Google Cloud SDK
* Docker with docker-compose
* Terraform
* Git account

> [!NOTE]
>If you have problems setting up the environment, you can check these videos.
>
>If you already have a working coding environment on local machine, these are optional. And only need to select one method. But if you have time to learn it now, these would be helpful if the local environment suddenly do not work one day.

## :movie_camera: GCP Cloud VM

### Setting up the environment on cloud VM
[![](https://markdown-videos-api.jorgenkh.no/youtube/ae-CV2KfoN0)](https://youtu.be/ae-CV2KfoN0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=14)

* Generating SSH keys
* Creating a virtual machine on GCP
* Connecting to the VM with SSH
* Installing Anaconda
* Installing Docker
* Creating SSH `config` file
* Accessing the remote machine with VS Code and SSH remote
* Installing docker-compose
* Installing pgcli
* Port-forwarding with VS code: connecting to pgAdmin and Jupyter from the local computer
* Installing Terraform
* Using `sftp` for putting the credentials to the remote machine
* Shutting down and removing the instance

## :movie_camera: GitHub Codespaces

### Preparing the environment with GitHub Codespaces

[![](https://markdown-videos-api.jorgenkh.no/youtube/XOSUt8Ih3zA)](https://youtu.be/XOSUt8Ih3zA&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=15)

# Homework

* [Homework](../cohorts/2025/01-docker-terraform/homework.md)


# Community notes

Did you take notes? You can share them here

* [Notes from Alvaro Navas](https://github.com/ziritrion/dataeng-zoomcamp/blob/main/notes/1_intro.md)
* [Notes from Abd](https://itnadigital.notion.site/Week-1-Introduction-f18de7e69eb4453594175d0b1334b2f4)
* [Notes from Aaron](https://github.com/ABZ-Aaron/DataEngineerZoomCamp/blob/master/week_1_basics_n_setup/README.md)
* [Notes from Faisal](https://github.com/FaisalMohd/data-engineering-zoomcamp/blob/main/week_1_basics_n_setup/Notes/DE%20Zoomcamp%20Week-1.pdf)
* [Michael Harty's Notes](https://github.com/mharty3/data_engineering_zoomcamp_2022/tree/main/week01)
* [Blog post from Isaac Kargar](https://kargarisaac.github.io/blog/data%20engineering/jupyter/2022/01/18/data-engineering-w1.html)
* [Handwritten Notes By Mahmoud Zaher](https://github.com/zaherweb/DataEngineering/blob/master/week%201.pdf)
* [Notes from Candace Williams](https://teacherc.github.io/data-engineering/2023/01/18/zoomcamp1.html)
* [Notes from Marcos Torregrosa](https://www.n4gash.com/2023/data-engineering-zoomcamp-semana-1/)
* [Notes from Vincenzo Galante](https://binchentso.notion.site/Data-Talks-Club-Data-Engineering-Zoomcamp-8699af8e7ff94ec49e6f9bdec8eb69fd)
* [Notes from Victor Padilha](https://github.com/padilha/de-zoomcamp/tree/master/week1)
* [Notes from froukje](https://github.com/froukje/de-zoomcamp/blob/main/week_1_basics_n_setup/notes/notes_week_01.md)
* [Notes from adamiaonr](https://github.com/adamiaonr/data-engineering-zoomcamp/blob/main/week_1_basics_n_setup/2_docker_sql/NOTES.md)
* [Notes from Xia He-Bleinagel](https://xiahe-bleinagel.com/2023/01/week-1-data-engineering-zoomcamp-notes/)
* [Notes from Balaji](https://github.com/Balajirvp/DE-Zoomcamp/blob/main/Week%201/Detailed%20Week%201%20Notes.ipynb)
* [Notes from Erik](https://twitter.com/ehub96/status/1621351266281730049)
* [Notes by Alain Boisvert](https://github.com/boisalai/de-zoomcamp-2023/blob/main/week1.md)
* Notes on [Docker, Docker Compose, and setting up a proper Python environment](https://medium.com/@verazabeida/zoomcamp-2023-week-1-f4f94cb360ae), by Vera
* [Setting up the development environment on Google Virtual Machine](https://itsadityagupta.hashnode.dev/setting-up-the-development-environment-on-google-virtual-machine), blog post by Aditya Gupta
* [Notes from Zharko Cekovski](https://www.zharconsulting.com/contents/data/data-engineering-bootcamp-2024/week-1-postgres-docker-and-ingestion-scripts/)
* [2024 Module-01 Walkthough video by ellacharmed on youtube](https://youtu.be/VUZshlVAnk4)
* [2024 Companion Module Walkthough slides by ellacharmed](https://github.com/ellacharmed/data-engineering-zoomcamp/blob/ella2024/cohorts/2024/01-docker-terraform/walkthrough-01.pdf)
* [2024 Module-01 Environment setup video by ellacharmed on youtube](https://youtu.be/Zce_Hd37NGs)
* [Docker Notes by Linda](https://github.com/inner-outer-space/de-zoomcamp-2024/blob/main/1a-docker_sql/readme.md) • [Terraform Notes by Linda](https://github.com/inner-outer-space/de-zoomcamp-2024/blob/main/1b-terraform_gcp/readme.md)
* [Notes from Hammad Tariq](https://github.com/hamad-tariq/HammadTariq-ZoomCamp2024/blob/9c8b4908416eb8cade3d7ec220e7664c003e9b11/week_1_basics_n_setup/README.md)
* [Hung's Notes](https://hung.bearblog.dev/docker/) & [Docker Cheatsheet](https://github.com/HangenYuu/docker-cheatsheet)
* [Kemal's Notes](https://github.com/kemaldahha/data-engineering-course/blob/main/week_1_notes.md)
* [Notes from Manuel Guerra (Windows+WSL2 Environment)](https://github.com/ManuelGuerra1987/data-engineering-zoomcamp-notes/blob/main/1_Containerization-and-Infrastructure-as-Code/README.md)
* [Notes from Horeb SEIDOU](https://spotted-hardhat-eea.notion.site/Week-1-Containerization-and-Infrastructure-as-Code-15729780dc4a80a08288e497ba937a37)
* [2025 Gitbook Notes from Tinker0425](https://data-engineering-zoomcamp-2025-t.gitbook.io/tinker0425/introduction/introduction-and-set-up)
* [Alex's Docker Notes](https://github.com/alexg9010/2025_data_engineering_zoomcamp/blob/master/01_docker/README.md) | [Alex's Terraform Notes](https://github.com/alexg9010/2025_data_engineering_zoomcamp/blob/master/01_3_terraform/README.md)
* [2025 SQL Refresher - Notes by Gabi Fonseca](https://github.com/fonsecagabriella/data_engineering/blob/main/01_docker_postgress/0_sql_refresh.ipynb)
* [2025 Setting up the Environment - Notes by Gabi Fonseca](https://github.com/fonsecagabriella/data_engineering/blob/main/01_docker_postgress/_setting_up.md)
* [Notes from Mercy Markus: Linux/Fedora Tweaks and Tips](https://mercymarkus.com/posts/2025/series/dtc-dez-jan-2025/dtc-dez-2025-module-1/)
* Add your notes above this line
