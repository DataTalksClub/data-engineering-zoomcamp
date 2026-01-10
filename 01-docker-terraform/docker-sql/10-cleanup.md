# Cleanup

**[↑ Up](README.md)** | **[← Previous](09-sql-refresher.md)** | **[Next →](../README.md)**

When you're done with the workshop, clean up Docker resources to free up disk space.

## Stop All Running Containers

```bash
docker-compose down
```

## Remove Specific Containers

```bash
# List all containers
docker ps -a

# Remove specific container
docker rm <container_id>

# Remove all stopped containers
docker container prune
```

## Remove Docker Images

```bash
# List all images
docker images

# Remove specific image
docker rmi taxi_ingest:v001

# Remove all unused images
docker image prune -a
```

## Remove Docker Volumes

```bash
# List volumes
docker volume ls

# Remove specific volumes
docker volume rm ny_taxi_postgres_data
docker volume rm pgadmin_data

# Remove all unused volumes
docker volume prune
```

## Remove Docker Networks

```bash
# List networks
docker network ls

# Remove specific network
docker network rm pg-network

# Remove all unused networks
docker network prune
```

## Complete Cleanup

Removes ALL Docker resources - use with caution!

```bash
# ⚠️ Warning: This removes ALL Docker resources!
docker system prune -a --volumes
```

## Clean Up Local Files

```bash
# Remove parquet files
rm *.parquet

# Remove Python cache
rm -rf __pycache__ .pytest_cache

# Remove virtual environment (if using venv)
rm -rf .venv
```

---

That's all for today. Happy learning! 🐳📊

**[↑ Up](README.md)** | **[← Previous](09-sql-refresher.md)** | **[Next →](../README.md)**
