docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  -d \
  --name zoomcamp_pg_admin \
  --network=zoomcamp-pg-network \
  --rm \
  dpage/pgadmin4
