docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v /home/amunoz/Proyectos/de-zoomcamp/zoomcap_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  -d \
  --name zoomcamp_postgres \
  --network=zoomcamp-pg-network \
  --rm \
  postgres:13