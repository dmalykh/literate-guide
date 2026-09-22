# Docker Command Reference

Registry: {{registry_url}} — Namespace: {{namespace}}

## Basic Commands

| Command | Description | Example |
|---------|-------------|---------|
| `docker run` | Create and run container | `docker run -p 8080:80 nginx` |
| `docker ps` | List running containers | `docker ps -a` |
| `docker stop` | Stop container | `docker stop container_name` |

## Quick Tips

- Use `docker logs container_name` to view container output
- Always specify image tags in production
- Use `.dockerignore` to exclude unnecessary files
