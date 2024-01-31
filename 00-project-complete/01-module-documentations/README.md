# Module 1: Containerization and Infrastructure as Code

- [1st Step: Environment setup ]()
- [2nd Step: Introduction to Docker]()
- [3rd Step: Running Postgres locally with Docker]()
- [4th Step: Using pgcli for connecting to the database]()
- [5th Step: How to re-run the existing Postgres container/server in Docker of this project]()
- [6th Step: Running pgAdmin]()
- [7th Step: Running Postgres and pgAdmin with Docker-Compose]()


## 1st Step: Environment setup 

### Browser setup
- [x] Fork [DE repo](https://github.com/DataTalksClub/data-engineering-zoomcamp)


### Google Cloud
- [x] Documentation how to setup [Google Cloud environment](https://github.com/agcdtmr/potential-pancake/blob/main/00-project-complete/00-01-docker-terraform/cloud-env-setup.md)

### GitHub Codespaces
- [x] Setup GitHub Codespaces

### Local setup

- [x] Clone [DE repo](https://github.com/DataTalksClub/data-engineering-zoomcamp) using ssh
- [x] Install Python using [Homebrew](https://github.com/agcdtmr/potential-pancake/blob/main/01-module-docker-terraform/how-to-install-python-on-macos-using-homebrew.md)
- [x] Install [Google Cloud SDK](https://cloud.google.com/sdk?hl=en) using [Homebrew](https://formulae.brew.sh/cask/google-cloud-sdk) `brew install --cask google-cloud-sdk`. 
- [x] Install the [gcloud CLI](https://cloud.google.com/sdk/docs/install) Note: To determine your machine hardware name, run `uname -m` from a command line.
- [x] Initialize the gcloud CLI `gcloud init`
- [x] Log in to GCP (on terminal) and choose the project for this repo
- [x] Install [Docker](https://formulae.brew.sh/formula/docker) with [Docker Compose](https://formulae.brew.sh/formula/docker-compose) using Homebrew
- [x] Successful run of `docker run hello-world`
- [x] Install Terraform using [Homebrew](https://formulae.brew.sh/formula/terraform)
- [ ] `cd Desktop/potential-pancake/00-project-complete/00-01-docker-terraform`

## 2nd Step: Introduction to Docker

- [x] Watch [DE Zoomcamp 1.2.1 - Introduction to Docker](https://www.youtube.com/watch?v=EYNwNlOrpr0&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb)
- [x] In this step I used Google Cloud environment, make sure to follow the [Google Cloud environment setup](https://github.com/agcdtmr/potential-pancake/blob/main/00-project-complete/00-01-docker-terraform/cloud-env-setup.md)
- [x] I copied the External IP of VM I created for this project
- [x] Paste the configuration snippet below to the config file, to automize the connection of my VM to my local machine via Secure Shell 
```
Host <VM Name>
  HostName <External IP>
  User <GCP username>
  IdentityFile ~/.ssh/<name of private ssh key>
```
- [x] Back to terminal, run `ssh <VM Name>`
- [x] Once I am in to the VM, run `docker run hello-world`

We can move forward if you get this message:
```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```
<img src="https://github.com/agcdtmr/potential-pancake/blob/main/00-project-complete/hello-world.png">

- [x] While following the "DE Zoomcamp 1.2.1 - Introduction to Docker" video I got a problem with docker build

```
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

error checking context: can't stat '/home/potential-pancake/01-docker-terraform/2_docker_sql/ny_taxi_postgres_data'

```
- [x] Go to this [docker buildx site](https://docs.docker.com/go/buildx/) to fix the error above
- [x] Reinstall [Docker Engine on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)
- [ ] Go to your file where Dockerfile is

```
FROM python:3.9

RUN pip install pandas

WORKDIR /app
COPY pipeline.py pipeline.py

ENTRYPOINT [ "python", "pipeline.py" ]
```



- [x] and run:
```
docker buildx create --use
docker buildx inspect default

docker buildx build -t test:pandas .
```

it will return similar output like this:
```
01-docker-terraform/2_docker_sql$ docker buildx build -t test:pandas .
[+] Building 77.6s (10/10) FINISHED                                                                      docker:default
 => [internal] load build definition from Dockerfile                                                               0.0s
 => => transferring dockerfile: 226B                                                                               0.0s
 => [internal] load metadata for docker.io/library/python:3.9.1                                                    1.3s
 => [internal] load .dockerignore                                                                                  0.0s
 => => transferring context: 2B                                                                                    0.0s
 => [1/5] FROM docker.io/library/python:3.9.1@sha256:ca8bd3c91af8b12c2d042ade99f7c8f578a9f80a0dbbd12ed261eeba96d  36.7s
 => => resolve docker.io/library/python:3.9.1@sha256:ca8bd3c91af8b12c2d042ade99f7c8f578a9f80a0dbbd12ed261eeba96dd  0.0s
 => => sha256:7467d1831b6947c294d92ee957902c3cd448b17c5ac2103ca5e79d15afb317c3 7.83MB / 7.83MB                     0.3s
 => => sha256:feab2c490a3cea21cc051ff29c33cc9857418edfa1be9966124b18abe1d5ae16 10.00MB / 10.00MB                   0.4s
 => => sha256:ca8bd3c91af8b12c2d042ade99f7c8f578a9f80a0dbbd12ed261eeba96dd632f 2.36kB / 2.36kB                     0.0s
 => => sha256:2a93c239d591553ed9c25ef20ed7c7a1542e8644f57d352e3a1446f0a5f0412d 8.33kB / 8.33kB                     0.0s
 => => sha256:0ecb575e629cd60aa802266a3bc6847dcf4073aa2a6d7d43f717dd61e7b90e0b 50.40MB / 50.40MB                   0.9s
 => => sha256:2a7e1b9e632b7a3a967dbddbf8c80fff234f10f9cb647b253c6405252db41c9c 2.22kB / 2.22kB                     0.0s
 => => sha256:f15a0f46f8c38f4ca7daecf160ba9cdb3ddeafda769e2741e179851cfaa14eec 51.83MB / 51.83MB                   1.3s
 => => sha256:937782447ff61abe49fd83ca9e3bdea338c1ae1d53278b2f31eca18ab4366a1e 192.33MB / 192.33MB                 4.5s
 => => extracting sha256:0ecb575e629cd60aa802266a3bc6847dcf4073aa2a6d7d43f717dd61e7b90e0b                          4.6s
 => => sha256:e78b7aaaab2cfb7598d50ad36633611a75bff6116d6a0acc2d37df61b5c797be 6.15MB / 6.15MB                     1.4s
 => => sha256:06c4d8634a1a306e07412154f682d30988cee9a788c10563e0143279d23fa69b 19.12MB / 19.12MB                   2.2s
 => => sha256:42b6aa65d161c7afc7d1b5741224751f55ea238144036e416037b02e22d73dff 231B / 231B                         1.5s
 => => sha256:f7fc0748308d6904bfdd5e91721ba058abdd1a415247a65089b44392f4be9fc9 2.16MB / 2.16MB                     1.7s
 => => extracting sha256:7467d1831b6947c294d92ee957902c3cd448b17c5ac2103ca5e79d15afb317c3                          0.5s
 => => extracting sha256:feab2c490a3cea21cc051ff29c33cc9857418edfa1be9966124b18abe1d5ae16                          0.4s
 => => extracting sha256:f15a0f46f8c38f4ca7daecf160ba9cdb3ddeafda769e2741e179851cfaa14eec                          4.1s
 => => extracting sha256:937782447ff61abe49fd83ca9e3bdea338c1ae1d53278b2f31eca18ab4366a1e                         19.9s
 => => extracting sha256:e78b7aaaab2cfb7598d50ad36633611a75bff6116d6a0acc2d37df61b5c797be                          1.1s
 => => extracting sha256:06c4d8634a1a306e07412154f682d30988cee9a788c10563e0143279d23fa69b                          2.9s
 => => extracting sha256:42b6aa65d161c7afc7d1b5741224751f55ea238144036e416037b02e22d73dff                          0.0s
 => => extracting sha256:f7fc0748308d6904bfdd5e91721ba058abdd1a415247a65089b44392f4be9fc9                          0.8s
 => [internal] load build context                                                                                  0.0s
 => => transferring context: 2.44kB                                                                                0.0s
 => [2/5] RUN apt-get install wget                                                                                 1.5s
 => [3/5] RUN pip install pandas sqlalchemy psycopg2                                                              35.7s
 => [4/5] WORKDIR /app                                                                                             0.1s
 => [5/5] COPY ingest_data.py ingest_data.py                                                                       0.1s
 => exporting to image                                                                                             2.1s
 => => exporting layers                                                                                            2.1s
 => => writing image sha256:fc870e8ed51bae2004dc8f87f085428ba631ef1fd74fcd2d50436d0d00383857                       0.0s
 => => naming to docker.io/library/test:pandas                                                                     0.0s

```

- [x] Deleted the GCP VM, as the disk was full and could not continue working there anymore
- [x] Because of all the issues and challenges, I decided to do the project in my local machine and successfully redone it

```
% cd test-docker 
(base) test-docker % touch Dockerfile
(base) test-docker % docker run hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (arm64v8)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/

(base)test-docker % ls
Dockerfile
(base) test-docker % docker build -t test:pandas
ERROR: "docker buildx build" requires exactly 1 argument.
See 'docker buildx build --help'.

Usage:  docker buildx build [OPTIONS] PATH | URL | -

Start a build
(base) test-docker % docker build -t test:pandas .
[+] Building 17.1s (6/6) FINISHED                          docker:desktop-linux
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 99B                                        0.0s
 => [internal] load metadata for docker.io/library/python:3.9              0.0s
 => [1/2] FROM docker.io/library/python:3.9                                0.0s
 => [2/2] RUN pip install pandas                                          16.6s
 => exporting to image                                                     0.5s 
 => => exporting layers                                                    0.4s 
 => => writing image sha256:c0b50f0933124abc78f2b75e58bba421b7164b52e55df  0.0s 
 => => naming to docker.io/library/test:pandas                             0.0s 
                                                                                
View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/yy1pos96ffg0b2ea0ozogfkza
(base)test-docker % docker build -t test:pandas .
[+] Building 0.0s (6/6) FINISHED                           docker:desktop-linux
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 99B                                        0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.9              0.0s
 => [1/2] FROM docker.io/library/python:3.9                                0.0s
 => CACHED [2/2] RUN pip install pandas                                    0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:c0b50f0933124abc78f2b75e58bba421b7164b52e55df  0.0s
 => => naming to docker.io/library/test:pandas                             0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/2uu2up83bo7mf81a8ivb5qwhx
(base)test-docker % ls
Dockerfile
(base) test-docker % docker run -it test:pandas
root@98f844a66877:/# python
Python 3.9.18 (main, Jan 17 2024, 05:48:03) 
[GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import pandas
<stdin>:1: DeprecationWarning: 
Pyarrow will become a required dependency of pandas in the next major release of pandas (pandas 3.0),
(to allow more performant data types, such as the Arrow string type, and better interoperability with other libraries)
but was not found to be installed on your system.
If this would cause problems for you,
please provide us feedback at https://github.com/pandas-dev/pandas/issues/54466
        
>>> pandas.__version__
'2.2.0'
>>> 
root@98f844a66877:/# 
exit
(base) test-docker % ls
Dockerfile
(base) test-docker % touch pipeline.py
(base) test-docker % docker build -t test:pandas .
[+] Building 0.0s (2/2) FINISHED                           docker:desktop-linux
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 117B                                       0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
Dockerfile:5
--------------------
   3 |     RUN pip install pandas
   4 |     
   5 | >>> COPY pipeline.py
   6 |     
   7 |     ENTRYPOINT [ "bash" ]
--------------------
ERROR: failed to solve: dockerfile parse error on line 5: COPY requires at least two arguments, but only one was provided. Destination could not be determined

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/cio6p5kbw368ba8fmsyhqn2vq
(base) test-docker % docker build -t test:pandas .
[+] Building 0.1s (9/9) FINISHED                           docker:desktop-linux
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 142B                                       0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.9              0.0s
 => [1/4] FROM docker.io/library/python:3.9                                0.0s
 => [internal] load build context                                          0.0s
 => => transferring context: 93B                                           0.0s
 => CACHED [2/4] RUN pip install pandas                                    0.0s
 => [3/4] WORKDIR /app                                                     0.0s
 => [4/4] COPY pipeline.py pipeline.py                                     0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:e03e61ea5ab4d6d9d2f6f354176721af80800535387d0  0.0s
 => => naming to docker.io/library/test:pandas                             0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/ji14kt72trrq6ymm27f4dadov
(base) test-docker % docker run -it test:pandas   
root@07aa220c8717:/app# ls
pipeline.py
root@07aa220c8717:/app# pwd
/app
root@07aa220c8717:/app# python pipeline.py 
/app/pipeline.py:1: DeprecationWarning: 
Pyarrow will become a required dependency of pandas in the next major release of pandas (pandas 3.0),
(to allow more performant data types, such as the Arrow string type, and better interoperability with other libraries)
but was not found to be installed on your system.
If this would cause problems for you,
please provide us feedback at https://github.com/pandas-dev/pandas/issues/54466
        
  import pandas as pd
job finished successfully
root@07aa220c8717:/app# exit
exit
(base) test-docker % docker build -t test:pandas .
[+] Building 0.1s (9/9) FINISHED                           docker:desktop-linux
 => [internal] load build definition from Dockerfile                       0.0s
 => => transferring dockerfile: 159B                                       0.0s
 => [internal] load .dockerignore                                          0.0s
 => => transferring context: 2B                                            0.0s
 => [internal] load metadata for docker.io/library/python:3.9              0.0s
 => [1/4] FROM docker.io/library/python:3.9                                0.0s
 => [internal] load build context                                          0.0s
 => => transferring context: 158B                                          0.0s
 => CACHED [2/4] RUN pip install pandas                                    0.0s
 => CACHED [3/4] WORKDIR /app                                              0.0s
 => [4/4] COPY pipeline.py pipeline.py                                     0.0s
 => exporting to image                                                     0.0s
 => => exporting layers                                                    0.0s
 => => writing image sha256:fe869984ff499c66577a159d70ee210b6b6ce36c9b435  0.0s
 => => naming to docker.io/library/test:pandas                             0.0s

View build details: docker-desktop://dashboard/build/desktop-linux/desktop-linux/p8ii86x49y8wj2cb1g4dw3emu
(base) test-docker % docker run -it test:pandas   
/app/pipeline.py:3: DeprecationWarning: 
Pyarrow will become a required dependency of pandas in the next major release of pandas (pandas 3.0),
(to allow more performant data types, such as the Arrow string type, and better interoperability with other libraries)
but was not found to be installed on your system.
If this would cause problems for you,
please provide us feedback at https://github.com/pandas-dev/pandas/issues/54466
        
  import pandas as pd
['pipeline.py']
Traceback (most recent call last):
  File "/app/pipeline.py", line 7, in <module>
    day = sys.argv[1]
IndexError: list index out of range
(base) test-docker % docker run -it test:pandas 2024-01-26
/app/pipeline.py:3: DeprecationWarning: 
Pyarrow will become a required dependency of pandas in the next major release of pandas (pandas 3.0),
(to allow more performant data types, such as the Arrow string type, and better interoperability with other libraries)
but was not found to be installed on your system.
If this would cause problems for you,
please provide us feedback at https://github.com/pandas-dev/pandas/issues/54466
        
  import pandas as pd
['pipeline.py', '2024-01-26']
job finished successfully for day = 2024-01-26
(base) test-docker % docker run -it test:pandas 2024-01-26 123 hello
/app/pipeline.py:3: DeprecationWarning: 
Pyarrow will become a required dependency of pandas in the next major release of pandas (pandas 3.0),
(to allow more performant data types, such as the Arrow string type, and better interoperability with other libraries)
but was not found to be installed on your system.
If this would cause problems for you,
please provide us feedback at https://github.com/pandas-dev/pandas/issues/54466
        
  import pandas as pd
['pipeline.py', '2024-01-26', '123', 'hello']
job finished successfully for day = 2024-01-26
(base) test-docker % 
```

## 3rd Step: Running Postgres locally with Docker

```
test-docker % ls
Dockerfile		docker-compose.yml	pipeline.py
(base) test-docker % pwd
/Users/Desktop/potential-pancake/00-project-complete/00-01-docker-terraform/test-docker
(base) test-docker % ls
Dockerfile		docker-compose.yml	pipeline.py
(base) test-docker % docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
docker: Error response from daemon: network pg-network not found.
(base) test-docker % docker ps
CONTAINER ID   IMAGE            COMMAND                  CREATED       STATUS       PORTS                           NAMES
5eec8d14f678   postgres:13      "docker-entrypoint.s…"   3 hours ago   Up 3 hours   0.0.0.0:5432->5432/tcp          2_docker_sql-pgdatabase-1
d01d30aa729e   dpage/pgadmin4   "/entrypoint.sh"         3 hours ago   Up 3 hours   443/tcp, 0.0.0.0:8080->80/tcp   2_docker_sql-pgadmin-1
(base) test-docker % docker rm 5eec8d14f678
Error response from daemon: You cannot remove a running container 5eec8d14f678093f2c3e05391992804ff563c491330fa57bd7927c1164b5bce1. Stop the container before attempting removal or force remove
(base) test-docker % docker ps             
CONTAINER ID   IMAGE            COMMAND                  CREATED       STATUS       PORTS                           NAMES
5eec8d14f678   postgres:13      "docker-entrypoint.s…"   3 hours ago   Up 3 hours   0.0.0.0:5432->5432/tcp          2_docker_sql-pgdatabase-1
d01d30aa729e   dpage/pgadmin4   "/entrypoint.sh"         3 hours ago   Up 3 hours   443/tcp, 0.0.0.0:8080->80/tcp   2_docker_sql-pgadmin-1
(base) test-docker % docker rm -f 5eec8d14f678
5eec8d14f678
(base) test-docker % docker ps                
CONTAINER ID   IMAGE            COMMAND            CREATED       STATUS       PORTS                           NAMES
d01d30aa729e   dpage/pgadmin4   "/entrypoint.sh"   3 hours ago   Up 3 hours   443/tcp, 0.0.0.0:8080->80/tcp   2_docker_sql-pgadmin-1
(base) test-docker % docker rm -f d01d30aa729e
d01d30aa729e
(base) test-docker % docker run -it \         
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
docker: Error response from daemon: Conflict. The container name "/pg-database" is already in use by container "16ea7b4d02b9388767b71391149efbffd8803d728159a65ec9c6dcfcfdade4b9". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
(base) test-docker % docker stop 16ea7b4d02b9  # Stop the existing container
docker rm 16ea7b4d02b9    # Remove the existing container
16ea7b4d02b9
Error response from daemon: No such container: #
Error response from daemon: No such container: Stop
Error response from daemon: No such container: the
Error response from daemon: No such container: existing
Error response from daemon: No such container: container
16ea7b4d02b9
Error response from daemon: No such container: #
Error response from daemon: No such container: Remove
Error response from daemon: No such container: the
Error response from daemon: No such container: existing
Error response from daemon: No such container: container
(base) test-docker % docker stop 16ea7b4d02b9
Error response from daemon: No such container: 16ea7b4d02b9
(base) test-docker % docker ps -a

CONTAINER ID   IMAGE          COMMAND                  CREATED             STATUS                         PORTS     NAMES
f9ef317623fb   test:pandas    "python pipeline.py …"   About an hour ago   Exited (0) About an hour ago             stupefied_varahamihira
8d63e0743508   test:pandas    "python pipeline.py …"   About an hour ago   Exited (0) About an hour ago             epic_hawking
012b543682e3   test:pandas    "python pipeline.py"     About an hour ago   Exited (1) About an hour ago             boring_boyd
07aa220c8717   e03e61ea5ab4   "bash"                   2 hours ago         Exited (0) 2 hours ago                   festive_kapitsa
98f844a66877   c0b50f093312   "bash"                   2 hours ago         Exited (0) 2 hours ago                   stoic_wright
59a6846774c4   hello-world    "/hello"                 2 hours ago         Exited (0) 2 hours ago                   sharp_wescoff
4c40f6853343   0148c7339525   "python ingest_data.…"   2 hours ago         Exited (2) 2 hours ago                   wonderful_bhabha
3718908d5e8a   0148c7339525   "python ingest_data.…"   3 hours ago         Exited (2) 3 hours ago                   kind_einstein
89a6ce56eaf4   python:3.9     "python3"                3 hours ago         Exited (0) 3 hours ago                   interesting_brahmagupta
c79b8db4f005   ubuntu         "bash"                   4 hours ago         Exited (0) 4 hours ago                   mystifying_galois
beb0928fc0a9   hello-world    "/hello"                 4 hours ago         Exited (0) 4 hours ago                   zealous_almeida
(base) test-docker % docker rm pg-database

Error response from daemon: No such container: pg-database
(base) test-docker % docker container prune

WARNING! This will remove all stopped containers.
Are you sure you want to continue? [y/N] y
Deleted Containers:
f9ef317623fb0d909cb785e092d83fd8a7aeee27247c01c65ce455b4c830eb4c
8d63e074350885d83ec851ad9aa6064f8f5e4531466fb05e46b0a0bb24ef9089
012b543682e3d25a944fc78b3558e89ba091df6292d14fa21e33c5dd367d8e4a
07aa220c8717a138e1e04f39a87c10ff832c135245f9aed06984828b0978be8e
98f844a668770ed49e5aead88f8e12e4b2f93232ff4f61c6dd27079c6e625858
59a6846774c4a6a6f66a218352107b87895b7a9edbaca4e2fba1e7b1a573396c
4c40f6853343b4df9261f5f42e748ddcb4c11d956885e8d7e0e8bd497c587ed0
3718908d5e8a5bf05f2aa75c3fd7c934ebe831dc3efe05e64594f8e78c3c942c
89a6ce56eaf4a6a9acb3e86626794ddc557d50cbdb1400fa21e99d8cbc9d747f
c79b8db4f005fbdcbdf6f589687b6f54b8e8427c6f8d58c7e069c829f01025e6
beb0928fc0a9a18a9bc4623a95bb905f895f68b4eeb173805fa53914d0c43bb8

Total reclaimed space: 1.232MB
(base) test-docker % docker ps -a          

CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
(base) test-docker % docker run -it \                                       
  -e POSTGRES_USER="root" \                              
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13
docker: Error response from daemon: network pg-network not found.
(base) test-docker % docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --name pg-database \
  postgres:13
docker: Error response from daemon: Conflict. The container name "/pg-database" is already in use by container "a9340f4e843c579253d3a9a1d311bb95db1aeb7d13e2b346ff6e74d7b374f743". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
(base) test-docker % docker rm -f a9340f4e843c579253d3a9a1d311bb95db1aeb7d13e2b346ff6e74d7b374f743
a9340f4e843c579253d3a9a1d311bb95db1aeb7d13e2b346ff6e74d7b374f743
(base) test-docker % docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --name pg-database \
  postgres:13
The files belonging to this database system will be owned by user "postgres".
This user must also own the server process.

The database cluster will be initialized with locale "en_US.utf8".
The default database encoding has accordingly been set to "UTF8".
The default text search configuration will be set to "english".

Data page checksums are disabled.

fixing permissions on existing directory /var/lib/postgresql/data ... ok
creating subdirectories ... ok
selecting dynamic shared memory implementation ... posix
selecting default max_connections ... 100
selecting default shared_buffers ... 128MB
selecting default time zone ... Etc/UTC
creating configuration files ... ok
running bootstrap script ... ok
performing post-bootstrap initialization ... ok
syncing data to disk ... ok

initdb: warning: enabling "trust" authentication for local connections
You can change this by editing pg_hba.conf or using the option -A, or
--auth-local and --auth-host, the next time you run initdb.

Success. You can now start the database server using:

    pg_ctl -D /var/lib/postgresql/data -l logfile start

waiting for server to start....2024-01-26 11:22:44.593 UTC [48] LOG:  starting PostgreSQL 13.13 (Debian 13.13-1.pgdg120+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 12.2.0-14) 12.2.0, 64-bit
2024-01-26 11:22:44.595 UTC [48] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2024-01-26 11:22:44.602 UTC [49] LOG:  database system was shut down at 2024-01-26 11:22:44 UTC
2024-01-26 11:22:44.607 UTC [48] LOG:  database system is ready to accept connections
 done
server started
CREATE DATABASE


/usr/local/bin/docker-entrypoint.sh: ignoring /docker-entrypoint-initdb.d/*

waiting for server to shut down...2024-01-26 11:22:45.536 UTC [48] LOG:  received fast shutdown request
.2024-01-26 11:22:45.538 UTC [48] LOG:  aborting any active transactions
2024-01-26 11:22:45.541 UTC [48] LOG:  background worker "logical replication launcher" (PID 55) exited with exit code 1
2024-01-26 11:22:45.541 UTC [50] LOG:  shutting down
2024-01-26 11:22:45.561 UTC [48] LOG:  database system is shut down
 done
server stopped

PostgreSQL init process complete; ready for start up.

2024-01-26 11:22:45.684 UTC [1] LOG:  starting PostgreSQL 13.13 (Debian 13.13-1.pgdg120+1) on aarch64-unknown-linux-gnu, compiled by gcc (Debian 12.2.0-14) 12.2.0, 64-bit
2024-01-26 11:22:45.685 UTC [1] LOG:  listening on IPv4 address "0.0.0.0", port 5432
2024-01-26 11:22:45.685 UTC [1] LOG:  listening on IPv6 address "::", port 5432
2024-01-26 11:22:45.689 UTC [1] LOG:  listening on Unix socket "/var/run/postgresql/.s.PGSQL.5432"
2024-01-26 11:22:45.702 UTC [63] LOG:  database system was shut down at 2024-01-26 11:22:45 UTC
2024-01-26 11:22:45.711 UTC [1] LOG:  database system is ready to accept connections
```

## 4th Step: Using pgcli for connecting to the database

```
test-docker % pip install pgcli
Requirement already satisfied: pgcli in /Users/#/anaconda3/lib/python3.11/site-packages (4.0.1)
Requirement already satisfied: pgspecial>=2.0.0 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (2.1.1)
Requirement already satisfied: click>=4.1 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (8.0.4)
Requirement already satisfied: Pygments>=2.0 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (2.15.1)
Requirement already satisfied: prompt-toolkit<4.0.0,>=2.0.6 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (3.0.36)
Requirement already satisfied: psycopg>=3.0.14 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (3.1.17)
Requirement already satisfied: sqlparse<0.5,>=0.3.0 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (0.4.4)
Requirement already satisfied: configobj>=5.0.6 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (5.0.8)
Requirement already satisfied: pendulum>=2.1.0 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (3.0.0)
Requirement already satisfied: cli-helpers[styles]>=2.2.1 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (2.3.0)
Requirement already satisfied: setproctitle>=1.1.9 in /Users/#/anaconda3/lib/python3.11/site-packages (from pgcli) (1.3.3)
Requirement already satisfied: tabulate[widechars]>=0.8.2 in /Users/#/anaconda3/lib/python3.11/site-packages (from cli-helpers[styles]>=2.2.1->pgcli) (0.8.10)
Requirement already satisfied: six in /Users/#/anaconda3/lib/python3.11/site-packages (from configobj>=5.0.6->pgcli) (1.16.0)
Requirement already satisfied: python-dateutil>=2.6 in /Users/#/anaconda3/lib/python3.11/site-packages (from pendulum>=2.1.0->pgcli) (2.8.2)
Requirement already satisfied: tzdata>=2020.1 in /Users/#/anaconda3/lib/python3.11/site-packages (from pendulum>=2.1.0->pgcli) (2023.3)
Requirement already satisfied: time-machine>=2.6.0 in /Users/#/anaconda3/lib/python3.11/site-packages (from pendulum>=2.1.0->pgcli) (2.13.0)
Requirement already satisfied: wcwidth in /Users/#/anaconda3/lib/python3.11/site-packages (from prompt-toolkit<4.0.0,>=2.0.6->pgcli) (0.2.5)
Requirement already satisfied: typing-extensions>=4.1 in /Users/#/anaconda3/lib/python3.11/site-packages (from psycopg>=3.0.14->pgcli) (4.7.1)
(base) #@CI00341580 test-docker % pgcli
connection is bad: No such file or directory
	Is the server running locally and accepting
	connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
(base) #@CI00341580 test-docker % pgcli --help
Usage: pgcli [OPTIONS] [DBNAME] [USERNAME]

Options:
  -h, --host TEXT         Host address of the postgres database.
  -p, --port INTEGER      Port number at which the postgres instance is
                          listening.
  -U, --username TEXT     Username to connect to the postgres database.
  -u, --user TEXT         Username to connect to the postgres database.
  -W, --password          Force password prompt.
  -w, --no-password       Never prompt for password.
  --single-connection     Do not use a separate connection for completions.
  -v, --version           Version of pgcli.
  -d, --dbname TEXT       database name to connect to.
  --pgclirc FILE          Location of pgclirc file.
  -D, --dsn TEXT          Use DSN configured into the [alias_dsn] section of
                          pgclirc file.
  --list-dsn              list of DSN configured into the [alias_dsn] section
                          of pgclirc file.
  --row-limit INTEGER     Set threshold for row limit prompt. Use 0 to disable
                          prompt.
  --less-chatty           Skip intro on startup and goodbye on exit.
  --prompt TEXT           Prompt format (Default: "\u@\h:\d> ").
  --prompt-dsn TEXT       Prompt format for connections using DSN aliases
                          (Default: "\u@\h:\d> ").
  -l, --list              list available databases, then exit.
  --auto-vertical-output  Automatically switch to vertical output mode if the
                          result is wider than the terminal width.
  --warn TEXT             Warn before running a destructive query.
  --ssh-tunnel TEXT       Open an SSH tunnel to the given address and connect
                          to the database from it.
  --help                  Show this message and exit.
(base) #@CI00341580 test-docker % pgcli -h localhost -p 5432 -u root -d ny_taxi
Server: PostgreSQL 13.13 (Debian 13.13-1.pgdg120+1)
Version: 4.0.1
Home: http://pgcli.com
root@localhost:ny_taxi> /dt
syntax error at or near "/"
LINE 1: /dt
        ^
Time: 0.039s
root@localhost:ny_taxi> \dt
+--------+------+------+-------+
| Schema | Name | Type | Owner |
|--------+------+------+-------|
+--------+------+------+-------+
SELECT 0
Time: 0.017s
root@localhost:ny_taxi>


```



- [x] Install and run jupyter notebook

```
~ % pip install jupyter
Requirement already satisfied: jupyter in ./anaconda3/lib/python3.11/site-packages (1.0.0)
Requirement already satisfied: notebook in ./anaconda3/lib/python3.11/site-packages (from jupyter) (6.5.4)
Requirement already satisfied: qtconsole in ./anaconda3/lib/python3.11/site-packages (from jupyter) (5.4.2)
Requirement already satisfied: jupyter-console in ./anaconda3/lib/python3.11/site-packages (from jupyter) (6.6.3)
Requirement already satisfied: nbconvert in ./anaconda3/lib/python3.11/site-packages (from jupyter) (6.5.4)
Requirement already satisfied: ipykernel in ./anaconda3/lib/python3.11/site-packages (from jupyter) (6.25.0)
Requirement already satisfied: ipywidgets in ./anaconda3/lib/python3.11/site-packages (from jupyter) (8.0.4)
Requirement already satisfied: appnope in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (0.1.2)
Requirement already satisfied: comm>=0.1.1 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (0.1.2)
Requirement already satisfied: debugpy>=1.6.5 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (1.6.7)
Requirement already satisfied: ipython>=7.23.1 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (8.15.0)
Requirement already satisfied: jupyter-client>=6.1.12 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (7.4.9)
Requirement already satisfied: jupyter-core!=5.0.*,>=4.12 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (5.3.0)
Requirement already satisfied: matplotlib-inline>=0.1 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (0.1.6)
Requirement already satisfied: nest-asyncio in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (1.5.6)
Requirement already satisfied: packaging in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (23.1)
Requirement already satisfied: psutil in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (5.9.0)
Requirement already satisfied: pyzmq>=20 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (23.2.0)
Requirement already satisfied: tornado>=6.1 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (6.3.2)
Requirement already satisfied: traitlets>=5.4.0 in ./anaconda3/lib/python3.11/site-packages (from ipykernel->jupyter) (5.7.1)
Requirement already satisfied: widgetsnbextension~=4.0 in ./anaconda3/lib/python3.11/site-packages (from ipywidgets->jupyter) (4.0.5)
Requirement already satisfied: jupyterlab-widgets~=3.0 in ./anaconda3/lib/python3.11/site-packages (from ipywidgets->jupyter) (3.0.5)
Requirement already satisfied: prompt-toolkit>=3.0.30 in ./anaconda3/lib/python3.11/site-packages (from jupyter-console->jupyter) (3.0.36)
Requirement already satisfied: pygments in ./anaconda3/lib/python3.11/site-packages (from jupyter-console->jupyter) (2.15.1)
Requirement already satisfied: lxml in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (4.9.3)
Requirement already satisfied: beautifulsoup4 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (4.12.2)
Requirement already satisfied: bleach in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (4.1.0)
Requirement already satisfied: defusedxml in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (0.7.1)
Requirement already satisfied: entrypoints>=0.2.2 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (0.4)
Requirement already satisfied: jinja2>=3.0 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (3.1.2)
Requirement already satisfied: jupyterlab-pygments in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (0.1.2)
Requirement already satisfied: MarkupSafe>=2.0 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (2.1.1)
Requirement already satisfied: mistune<2,>=0.8.1 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (0.8.4)
Requirement already satisfied: nbclient>=0.5.0 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (0.5.13)
Requirement already satisfied: nbformat>=5.1 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (5.9.2)
Requirement already satisfied: pandocfilters>=1.4.1 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (1.5.0)
Requirement already satisfied: tinycss2 in ./anaconda3/lib/python3.11/site-packages (from nbconvert->jupyter) (1.2.1)
Requirement already satisfied: argon2-cffi in ./anaconda3/lib/python3.11/site-packages (from notebook->jupyter) (21.3.0)
Requirement already satisfied: ipython-genutils in ./anaconda3/lib/python3.11/site-packages (from notebook->jupyter) (0.2.0)
Requirement already satisfied: Send2Trash>=1.8.0 in ./anaconda3/lib/python3.11/site-packages (from notebook->jupyter) (1.8.0)
Requirement already satisfied: terminado>=0.8.3 in ./anaconda3/lib/python3.11/site-packages (from notebook->jupyter) (0.17.1)
Requirement already satisfied: prometheus-client in ./anaconda3/lib/python3.11/site-packages (from notebook->jupyter) (0.14.1)
Requirement already satisfied: nbclassic>=0.4.7 in ./anaconda3/lib/python3.11/site-packages (from notebook->jupyter) (0.5.5)
Requirement already satisfied: qtpy>=2.0.1 in ./anaconda3/lib/python3.11/site-packages (from qtconsole->jupyter) (2.2.0)
Requirement already satisfied: backcall in ./anaconda3/lib/python3.11/site-packages (from ipython>=7.23.1->ipykernel->jupyter) (0.2.0)
Requirement already satisfied: decorator in ./anaconda3/lib/python3.11/site-packages (from ipython>=7.23.1->ipykernel->jupyter) (5.1.1)
Requirement already satisfied: jedi>=0.16 in ./anaconda3/lib/python3.11/site-packages (from ipython>=7.23.1->ipykernel->jupyter) (0.18.1)
Requirement already satisfied: pickleshare in ./anaconda3/lib/python3.11/site-packages (from ipython>=7.23.1->ipykernel->jupyter) (0.7.5)
Requirement already satisfied: stack-data in ./anaconda3/lib/python3.11/site-packages (from ipython>=7.23.1->ipykernel->jupyter) (0.2.0)
Requirement already satisfied: pexpect>4.3 in ./anaconda3/lib/python3.11/site-packages (from ipython>=7.23.1->ipykernel->jupyter) (4.8.0)
Requirement already satisfied: python-dateutil>=2.8.2 in ./anaconda3/lib/python3.11/site-packages (from jupyter-client>=6.1.12->ipykernel->jupyter) (2.8.2)
Requirement already satisfied: platformdirs>=2.5 in ./anaconda3/lib/python3.11/site-packages (from jupyter-core!=5.0.*,>=4.12->ipykernel->jupyter) (3.10.0)
Requirement already satisfied: jupyter-server>=1.8 in ./anaconda3/lib/python3.11/site-packages (from nbclassic>=0.4.7->notebook->jupyter) (1.23.4)
Requirement already satisfied: notebook-shim>=0.1.0 in ./anaconda3/lib/python3.11/site-packages (from nbclassic>=0.4.7->notebook->jupyter) (0.2.2)
Requirement already satisfied: fastjsonschema in ./anaconda3/lib/python3.11/site-packages (from nbformat>=5.1->nbconvert->jupyter) (2.16.2)
Requirement already satisfied: jsonschema>=2.6 in ./anaconda3/lib/python3.11/site-packages (from nbformat>=5.1->nbconvert->jupyter) (4.17.3)
Requirement already satisfied: wcwidth in ./anaconda3/lib/python3.11/site-packages (from prompt-toolkit>=3.0.30->jupyter-console->jupyter) (0.2.5)
Requirement already satisfied: ptyprocess in ./anaconda3/lib/python3.11/site-packages (from terminado>=0.8.3->notebook->jupyter) (0.7.0)
Requirement already satisfied: argon2-cffi-bindings in ./anaconda3/lib/python3.11/site-packages (from argon2-cffi->notebook->jupyter) (21.2.0)
Requirement already satisfied: soupsieve>1.2 in ./anaconda3/lib/python3.11/site-packages (from beautifulsoup4->nbconvert->jupyter) (2.4)
Requirement already satisfied: six>=1.9.0 in ./anaconda3/lib/python3.11/site-packages (from bleach->nbconvert->jupyter) (1.16.0)
Requirement already satisfied: webencodings in ./anaconda3/lib/python3.11/site-packages (from bleach->nbconvert->jupyter) (0.5.1)
Requirement already satisfied: parso<0.9.0,>=0.8.0 in ./anaconda3/lib/python3.11/site-packages (from jedi>=0.16->ipython>=7.23.1->ipykernel->jupyter) (0.8.3)
Requirement already satisfied: attrs>=17.4.0 in ./anaconda3/lib/python3.11/site-packages (from jsonschema>=2.6->nbformat>=5.1->nbconvert->jupyter) (22.1.0)
Requirement already satisfied: pyrsistent!=0.17.0,!=0.17.1,!=0.17.2,>=0.14.0 in ./anaconda3/lib/python3.11/site-packages (from jsonschema>=2.6->nbformat>=5.1->nbconvert->jupyter) (0.18.0)
Requirement already satisfied: anyio<4,>=3.1.0 in ./anaconda3/lib/python3.11/site-packages (from jupyter-server>=1.8->nbclassic>=0.4.7->notebook->jupyter) (3.5.0)
Requirement already satisfied: websocket-client in ./anaconda3/lib/python3.11/site-packages (from jupyter-server>=1.8->nbclassic>=0.4.7->notebook->jupyter) (0.58.0)
Requirement already satisfied: cffi>=1.0.1 in ./anaconda3/lib/python3.11/site-packages (from argon2-cffi-bindings->argon2-cffi->notebook->jupyter) (1.15.1)
Requirement already satisfied: executing in ./anaconda3/lib/python3.11/site-packages (from stack-data->ipython>=7.23.1->ipykernel->jupyter) (0.8.3)
Requirement already satisfied: asttokens in ./anaconda3/lib/python3.11/site-packages (from stack-data->ipython>=7.23.1->ipykernel->jupyter) (2.0.5)
Requirement already satisfied: pure-eval in ./anaconda3/lib/python3.11/site-packages (from stack-data->ipython>=7.23.1->ipykernel->jupyter) (0.2.2)
Requirement already satisfied: idna>=2.8 in ./anaconda3/lib/python3.11/site-packages (from anyio<4,>=3.1.0->jupyter-server>=1.8->nbclassic>=0.4.7->notebook->jupyter) (3.4)
Requirement already satisfied: sniffio>=1.1 in ./anaconda3/lib/python3.11/site-packages (from anyio<4,>=3.1.0->jupyter-server>=1.8->nbclassic>=0.4.7->notebook->jupyter) (1.2.0)
Requirement already satisfied: pycparser in ./anaconda3/lib/python3.11/site-packages (from cffi>=1.0.1->argon2-cffi-bindings->argon2-cffi->notebook->jupyter) (2.21)
(base) #@CI00341580 ~ % jupyter notebook

  _   _          _      _
 | | | |_ __  __| |__ _| |_ ___
 | |_| | '_ \/ _` / _` |  _/ -_)
  \___/| .__/\__,_\__,_|\__\___|
       |_|
                       
Read the migration plan to Notebook 7 to learn about the new features and the actions to take if you are using extensions.

https://jupyter-notebook.readthedocs.io/en/latest/migrate_to_notebook7.html

Please note that updating to Notebook 7 might break some of your extensions.

[W 12:38:12.761 NotebookApp] Loading JupyterLab as a classic notebook (v6) extension.
[I 2024-01-26 12:38:12.764 LabApp] JupyterLab extension loaded from /Users/#/anaconda3/lib/python3.11/site-packages/jupyterlab
[I 2024-01-26 12:38:12.764 LabApp] JupyterLab application directory is /Users/#/anaconda3/share/jupyter/lab
[I 12:38:19.454 NotebookApp] Serving notebooks from local directory: /Users/#
[I 12:38:19.454 NotebookApp] Jupyter Notebook 6.5.4 is running at:
[I 12:38:19.454 NotebookApp] http://localhost:8888/?token=e791ce74e0011a189cdd9319ca267e91a2e37350b46d090d
[I 12:38:19.454 NotebookApp]  or http://127.0.0.1:8888/?token=e791ce74e0011a189cdd9319ca267e91a2e37350b46d090d
[I 12:38:19.454 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 12:38:19.470 NotebookApp] 
```


- [x] Download the dataset of NY Taxi

- [x] because the `wget https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz` did not appear to have any data, I used the link below instead using a parquet file directly from https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page

```
curl -O https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100     9  100     9    0     0     41      0 --:--:-- --:--:-- --:--:--    41
(base) #@CI00341580 test-docker % ls
Dockerfile			upload-data.ipynb
docker-compose.yml		yellow_tripdata_2021-01.csv
ny_taxi_postgres_data		yellow_tripdata_2021-01.csv.gz
pipeline.py
(base) #@CI00341580 test-docker % rm yellow_tripdata_2021-01.csv.gz
(base) #@CI00341580 test-docker % ls
Dockerfile			pipeline.py
docker-compose.yml		upload-data.ipynb
ny_taxi_postgres_data		yellow_tripdata_2021-01.csv
(base) #@CI00341580 test-docker % less yellow_tripdata_2021-01.csv
END
```


- [x] Reading csv with pandas
- [x] Upload-data.ipyd change the following code:

```
df = pd.read_csv('yellow_tripdata_2021-01.csv', nrows=100)
```

to

```
df = pd.read_parquet('yellow_tripdata_2023-01.parquet')
df.to_csv('yellow_tripdata_2023-01.csv')

df = pd.read_csv('yellow_tripdata_2023-01.csv', nrows=100)

# Display the DataFrame
print(df)
```


- [x] when running `print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))`. I get the error "ModuleNotFoundError: No module named 'psycopg2'"

```
pip3 install psycopg2

Collecting psycopg2
  Downloading psycopg2-2.9.9.tar.gz (384 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 384.9/384.9 kB 4.0 MB/s eta 0:00:00
  Preparing metadata (setup.py) ... done
Building wheels for collected packages: psycopg2
  Building wheel for psycopg2 (setup.py) ... done
  Created wheel for psycopg2: filename=psycopg2-2.9.9-cp311-cp311-macosx_11_0_arm64.whl size=132032 sha256=5ba7f92eb69addf8a54a78f1aed187d87966a3a84046de7a9a034c0a22dcb002
  Stored in directory: /Users/#/Library/Caches/pip/wheels/ab/34/b9/78ebef1b3220b4840ee482461e738566c3c9165d2b5c914f51
Successfully built psycopg2
Installing collected packages: psycopg2
Successfully installed psycopg2-2.9.9
(base) #@CI00341580 test-docker % 

```

- [x] Installing sqlAlchemy and connect to Postgres

```
pip install sqlalchemy
Requirement already satisfied: sqlalchemy in /Users/#/anaconda3/lib/python3.11/site-packages (1.4.39)

```



- [x] Generating Postgres compatible DDL

`df.head(n=0).to_sql(name='yellow_taxi_data', con=engine, if_exists='replace')`

```
root@localhost:ny_taxi> \dt
+--------+------------------+-------+-------+
| Schema | Name             | Type  | Owner |
|--------+------------------+-------+-------|
| public | yellow_taxi_data | table | root  |
+--------+------------------+-------+-------+
SELECT 1
Time: 0.020s

root@localhost:ny_taxi> \d yellow_taxi_data
+-----------------------+-----------------------------+-----------+
| Column                | Type                        | Modifiers |
|-----------------------+-----------------------------+-----------|
| index                 | bigint                      |           |
| Unnamed: 0            | bigint                      |           |
| VendorID              | bigint                      |           |
| tpep_pickup_datetime  | timestamp without time zone |           |
| tpep_dropoff_datetime | timestamp without time zone |           |
| passenger_count       | double precision            |           |
| trip_distance         | double precision            |           |
| RatecodeID            | double precision            |           |
| store_and_fwd_flag    | text                        |           |
| PULocationID          | bigint                      |           |
| DOLocationID          | bigint                      |           |
| payment_type          | bigint                      |           |
| fare_amount           | double precision            |           |
| extra                 | double precision            |           |
| mta_tax               | double precision            |           |
| tip_amount            | double precision            |           |
| tolls_amount          | double precision            |           |
| improvement_surcharge | double precision            |           |
| total_amount          | double precision            |           |
| congestion_surcharge  | double precision            |           |
:
```

`%time df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')`

```
root@localhost:ny_taxi> SELECT count(1) FROM yellow_taxi_data
+--------+
| count  |
|--------|
| 100000 |
+--------+
SELECT 1
Time: 0.043s
root@localhost:ny_taxi>

```


- [x] Ingesting the CSV data in chunks


Error
```
while True: 
    t_start = time()

    df = next(df_iter)

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    
    df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')

    t_end = time()

    print('inserted another chunk, took %.3f second' % (t_end - t_start))

---------------------------------------------------------------------------
StopIteration                             Traceback (most recent call last)
Cell In[103], line 4
      1 while True: 
      2     t_start = time()
----> 4     df = next(df_iter)
      6     df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
      7     df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)

File ~/anaconda3/lib/python3.11/site-packages/pandas/io/parsers/readers.py:1624, in TextFileReader.__next__(self)
   1622 def __next__(self) -> DataFrame:
   1623     try:
-> 1624         return self.get_chunk()
   1625     except StopIteration:
   1626         self.close()

File ~/anaconda3/lib/python3.11/site-packages/pandas/io/parsers/readers.py:1733, in TextFileReader.get_chunk(self, size)
   1731         raise StopIteration
   1732     size = min(size, self.nrows - self._currow)
-> 1733 return self.read(nrows=size)

File ~/anaconda3/lib/python3.11/site-packages/pandas/io/parsers/readers.py:1704, in TextFileReader.read(self, nrows)
   1697 nrows = validate_integer("nrows", nrows)
   1698 try:
   1699     # error: "ParserBase" has no attribute "read"
   1700     (
   1701         index,
   1702         columns,
   1703         col_dict,
-> 1704     ) = self._engine.read(  # type: ignore[attr-defined]
   1705         nrows
   1706     )
   1707 except Exception:
   1708     self.close()

File ~/anaconda3/lib/python3.11/site-packages/pandas/io/parsers/c_parser_wrapper.py:234, in CParserWrapper.read(self, nrows)
    232 try:
    233     if self.low_memory:
--> 234         chunks = self._reader.read_low_memory(nrows)
    235         # destructive to chunks
    236         data = _concatenate_chunks(chunks)

File ~/anaconda3/lib/python3.11/site-packages/pandas/_libs/parsers.pyx:839, in pandas._libs.parsers.TextReader.read_low_memory()

StopIteration: 

```


- [x] I asked ChatGPT what could be wrong

```
It looks like you're encountering a `StopIteration` error, which is raised when there are no more items to be returned by the iterator. In Python, the `next()` function raises `StopIteration` when it reaches the end of the iterator.

In your case, it seems that the `df_iter` iterator has reached the end of the data. You are using the `next(df_iter)` statement to get the next chunk of data, and when there are no more chunks, it raises the `StopIteration` error.

To handle this gracefully, you can catch the `StopIteration` exception and break out of the loop when there is no more data. You can modify your code like this:

```python
while True:
    t_start = time()

    try:
        df = next(df_iter)
    except StopIteration:
        # No more data, break out of the loop
        break

    df.tpep_pickup_datetime = pd.to_datetime(df.tpep_pickup_datetime)
    df.tpep_dropoff_datetime = pd.to_datetime(df.tpep_dropoff_datetime)
    
    df.to_sql(name='yellow_taxi_data', con=engine, if_exists='append')

    t_end = time()

    print('inserted another chunk, took %.3f second' % (t_end - t_start))
```

This modification ensures that the loop breaks when there are no more items in the iterator, preventing the `StopIteration` error from being raised.

This was the result
 
```
root@localhost:ny_taxi> SELECT count(1) FROM yellow_taxi_data
+---------+
| count   |
|---------|
| 3066766 |
+---------+
SELECT 1
Time: 0.617s
root@localhost:ny_taxi>
```


Note: if you have problems with pgcli, check the video below for an alternative way to connect to your database
- [ ] DE Zoomcamp 1.2.2 - Optional: [Connecting to Postgres with Jupyter and Pandas](https://www.youtube.com/watch?v=3IkfkTwqHx4&list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb&index=6)

## 5th Step: How to re-run the existing Postgres container/server in Docker of this project

- [x] How to re-run the existing Postgres container/server in Docker using pgcli (terminal not a GUI)

- [x] Open Docker Desktop
- [x] Go to terminal and go to your project file
`cd 00-project-complete/00-01-docker-terraform/test-module1`
- [x] Use commands below to connect to the postgres database
```
docker stop pg-database
docker start pg-database
docker logs pg-database
docker restart pg-database
pgcli -h localhost -p 5432 -u root -d ny_taxi
root@localhost:ny_taxi> SELECT count(1) FROM yellow_taxi_data
```

## 6th Step: Running pgAdmin

- [x] Running pgAdmin
```
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  dpage/pgadmin4
```

- [x] Running Postgres and pgAdmin together


- [x] Register a server

```
## type of db: user:password@localhost:port/dbName
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
```

Server Name: Local Docker
Connection:
- Host name/address: localhost
- Port: 5432
- Maintenance database: postgres
- Username: root
- Password: root

- [x] In this project, I am running postgres in a docker container and pgAdmin is running locally. The registering of registering the postgres server above will result an error.
- [x] We first need to connect the postgres server/container to pgAdmin local server. For that we use network. We put the postgres server/container and pgAdmin in one network.

[docker network create documentation](https://docs.docker.com/engine/reference/commandline/network_create/)


- [x] Running Postgres and pgAdmin together

- [x] Create a network
```
docker network create <name you want for the network>
docker network create pg-network
```


 - [x] Run Postgres (change the path)

```

docker stop pg-database


docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v ${pwd}/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=pg-network \
  --name pg-database \
  postgres:13

pgcli -h localhost -p 5432 -u root -d ny_taxi
```
- [x] Check if the data still exist
```
root@localhost:ny_taxi> SELECT count(1) FROM yellow_taxi_data
```

 - [x] Run pgAdmin

```
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4
```

- [x] Go back to localhost:8080 or pgadmin server and register the postgres server
```
## type of db: user:password@localhost:port/dbName
engine = create_engine('postgresql://root:root@localhost:5432/ny_taxi')
```

- [x] **Server Name:** Local Docker
- [x] **Connection:**
- Host name/address: pgdatabase
- Port: 5432
- Maintenance database: postgres
- Username: root
- Password: root


## 7th Step: Running Postgres and pgAdmin with Docker-Compose

- [x] In this step, make sure your 'ny_taxi_postgres_data' folder and docker-compose.yaml is in one directory
- [x] When you did that run:
```
docker-compose up
```
- [x] or with -d (detach) so you can continously working in one terminal
```
docker-compose up -d
```

- [x] The commands above will return
```
[+] Building 0.0s (0/0)                                                                               docker:desktop-linux
[+] Running 3/3
 ✔ Network test-module1_default         Created                                                                       0.0s 
 ✔ Container test-module1-pgdatabase-1  Started                                                                       0.0s 
 ✔ Container test-module1-pgadmin-1     Started                                                                       0.0s 
```

- [x] Go to http://localhost:8080/ and register the postgres server:

- [x] **Server Name:** Local Docker
- [x] **Connection:**
- Host name/address: pgdatabase
- Port: 5432
- Maintenance database: postgres
- Username: root
- Password: root


- [x] On the left side of your pgadmin window, you can click the dropdown for 'Server'. Find your newly created Server and Database.
- [x] Try: Go to yellow_taxi_data under Table and view/edit data -> First 100 row.
- [x] From here I can continue working with the data inside the postgres server using pgadmin GUI.
- [x]  `docker-compose down` to stop the containers.
