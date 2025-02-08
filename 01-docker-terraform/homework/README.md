# Module 1 Homework: Docker & SQL
In this homework we'll prepare the environment and practice Docker and SQL

## Question 1. Understanding docker first run
Run docker with the `python:3.12.8` image in an interactive mode, use the entrypoint bash.

The version of `pip` in the image is: `24.3.1`


## Question 2. Understanding Docker networking and docker-compose

Given the following `docker-compose.yaml`, **pgadmin** should use the following to connect to the postgres database:
- hostname: db
    - use the **service name** for hostname
- port: 5432 
    - the ports mapping (5433:5432) only affects connections from **outside Docker** (e.g., from your host machine). Inside the Docker network, pgAdmin connects to Postgres on port 5432.


```yaml
services:
  db:
    container_name: postgres
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: 'postgres'
      POSTGRES_PASSWORD: 'postgres'
      POSTGRES_DB: 'ny_taxi'
    ports:
      - '5433:5432'
    volumes:
      - vol-pgdata:/var/lib/postgresql/data

  pgadmin:
    container_name: pgadmin
    image: dpage/pgadmin4:latest
    environment:
      PGADMIN_DEFAULT_EMAIL: "pgadmin@pgadmin.com"
      PGADMIN_DEFAULT_PASSWORD: "pgadmin"
    ports:
      - "8080:80"
    volumes:
      - vol-pgadmin_data:/var/lib/pgadmin  

volumes:
  vol-pgdata:
    name: vol-pgdata
  vol-pgadmin_data:
    name: vol-pgadmin_data
```