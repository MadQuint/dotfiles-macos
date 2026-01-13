#!/bin/bash
# Code-Server Management Script

COMPOSE_FILE="/Users/gianni/Projects/.code-server/docker-compose.yml"

case "$1" in
  start)
    echo "Starting code-server..."
    cd /Users/gianni/Projects/.code-server && docker compose up -d
    echo "Code-server is running at http://localhost:8080"
    ;;
  stop)
    echo "Stopping code-server..."
    cd /Users/gianni/Projects/.code-server && docker compose down
    ;;
  restart)
    echo "Restarting code-server..."
    cd /Users/gianni/Projects/.code-server && docker compose restart
    ;;
  logs)
    cd /Users/gianni/Projects/.code-server && docker compose logs -f
    ;;
  status)
    cd /Users/gianni/Projects/.code-server && docker compose ps
    ;;
  update)
    echo "Updating code-server..."
    cd /Users/gianni/Projects/.code-server && docker compose pull && docker compose up -d
    ;;
  *)
    echo "Usage: $0 {start|stop|restart|logs|status|update}"
    exit 1
    ;;
esac
