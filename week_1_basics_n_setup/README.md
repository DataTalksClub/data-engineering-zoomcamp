### Introduction

* [Video](https://www.youtube.com/watch?v=-zpVha7bw5A)
* [Slides](https://www.slideshare.net/AlexeyGrigorev/data-engineering-zoomcamp-introduction)
* Overview of [Architecture](https://github.com/DataTalksClub/data-engineering-zoomcamp#overview), [Technologies](https://github.com/DataTalksClub/data-engineering-zoomcamp#technologies) & [Pre-Requisites](https://github.com/DataTalksClub/data-engineering-zoomcamp#prerequisites)


We suggest watching videos in the same order as in this document.

The last video (setting up the environment) is optional, but you can check it earlier 
if you have troubles setting up the environment and following along with the videos.


### Docker + Postgres

[Code](2_docker_sql)

* [Introduction to Docker](https://www.youtube.com/watch?v=EYNwNlOrpr0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * Why do we need Docker
  * Creating a simple "data pipeline" in Docker
* [Ingesting NY Taxi Data to Postgres](https://www.youtube.com/watch?v=2JM-ziJt0WI&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * Running Postgres locally with Docker
  * Using `pgcli` for connecting to the database
  * Exploring the NY Taxi dataset
  * Ingesting the data into the database
  * **Note** if you have problems with `pgcli`, check [this video](https://www.youtube.com/watch?v=3IkfkTwqHx4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
    for an alternative way to connect to your database
* [Connecting pgAdmin and Postgres](https://www.youtube.com/watch?v=hCAIVe9N0ow&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * The pgAdmin tool
  * Docker networks
* [Putting the ingestion script into Docker](https://www.youtube.com/watch?v=B1WwATwf-vY&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * Converting the Jupyter notebook to a Python script
  * Parametrizing the script with argparse
  * Dockerizing the ingestion script
* [Running Postgres and pgAdmin with Docker-Compose](https://www.youtube.com/watch?v=hKI6PkPhpa0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * Why do we need Docker-compose
  * Docker-compose YAML file
  * Running multiple containers with `docker-compose up`
* [SQL refresher](https://www.youtube.com/watch?v=QEcps_iskgg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * Adding the Zones table
  * Inner joins
  * Basic data quality checks
  * Left, Right and Outer joins
  * Group by
* Optional: If you have some problems with docker networking, check [Port Mapping and Networks in Docker](https://www.youtube.com/watch?v=tOr4hTsHOzU&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * Docker networks
  * Port forwarding to the host environment
  * Communicating between containers in the network
  * `.dockerignore` file
* Optional: If you are willing to do the steps from "Ingesting NY Taxi Data to Postgres" till "Running Postgres and pgAdmin with Docker-Compose" with Windows Subsystem Linux please check [Docker Module Walk-Through on WSL](https://www.youtube.com/watch?v=Mv4zFm2AwzQ)


### GCP + Terraform

[Code](1_terraform_gcp)

* Introduction to GCP (Google Cloud Platform)
  * [Video](https://www.youtube.com/watch?v=18jIzE41fJ4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
* Introduction to Terraform Concepts & GCP Pre-Requisites
  * [Video](https://www.youtube.com/watch?v=Hajwnmj0xfQ&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * [Companion Notes](1_terraform_gcp)
* Workshop: Creating GCP Infrastructure with Terraform
  * [Video](https://www.youtube.com/watch?v=dNkEgO-CExg&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
  * [Workshop](1_terraform_gcp/terraform)
* Configuring terraform and GCP SDK on Windows
  * [Instructions](1_terraform_gcp/windows.md)


### Environment setup 

For the course you'll need:

* Python 3 (e.g. installed with Anaconda)
* Google Cloud SDK
* Docker with docker-compose
* Terraform

If you have problems setting up the env, you can check this video:

* [Setting up the environment on cloud VM](https://www.youtube.com/watch?v=ae-CV2KfoN0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
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

### Homework

* [Homework](../cohorts/2023/week_1_docker_sql/homework.md)
* [Homework-PartB](../cohorts/2023/week_1_terraform/homework.md)


## Community notes

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
* Add your notes here
