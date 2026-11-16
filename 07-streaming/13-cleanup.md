---
prev_url: 12-understanding-window-types.md
next_url: 14-questions-and-answers.md
---
# Cleanup


*`docker compose down` removes the services while preserving the volume; adding `-v` removes the persisted database data too.*

Stop and remove all containers:

```bash
docker compose down
```

To also remove the PostgreSQL data volume:

```bash
docker compose down -v
```

<!-- nav:start -->
[← Previous: Understanding window types](12-understanding-window-types.md) · [Next: Q&A →](14-questions-and-answers.md)
<!-- nav:end -->
