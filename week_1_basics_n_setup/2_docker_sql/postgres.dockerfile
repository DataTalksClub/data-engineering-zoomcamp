docker network create pg-network

docker run -it  \
   -e POSTGRES_USER="root"  \
   -e POSTGRES_PASSWORD="root" \
   -e POSTGRES_DB="ny_taxi"  \
   -v /home/gosha/data-engineering-zoomcamp/week_1_basics_n_setup/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/data \
   -p 5432:5432  \
   --network=pg-network \
   --name pg-database \
   postgres:13


   docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
   --network=pg-network \
   --name pgadmin \
   dpage/pgadmin4

