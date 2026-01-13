#!/bin/bash
# Coder Management Script

COMPOSE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$COMPOSE_DIR/docker-compose.yml"

cd "$COMPOSE_DIR"

case "$1" in
  start)
    echo "Starting Coder..."
    docker compose up -d
    echo ""
    echo "✓ Coder is starting up..."
    echo "  → Web UI: http://localhost:7080"
    echo ""
    echo "First-time setup:"
    echo "  1. Open http://localhost:7080 in your browser"
    echo "  2. Create your first admin user"
    echo "  3. Install the Coder VS Code extension"
    echo "  4. Create a workspace using a template"
    ;;
  stop)
    echo "Stopping Coder..."
    docker compose down
    ;;
  restart)
    echo "Restarting Coder..."
    docker compose restart
    ;;
  logs)
    docker compose logs -f coder
    ;;
  logs-all)
    docker compose logs -f
    ;;
  status)
    docker compose ps
    ;;
  update)
    echo "Updating Coder to latest version..."
    docker compose pull
    docker compose up -d
    echo "✓ Coder updated"
    ;;
  clean)
    echo "⚠️  This will remove all Coder data including workspaces!"
    read -p "Are you sure? (yes/no): " confirm
    if [ "$confirm" = "yes" ]; then
      docker compose down -v
      echo "✓ Coder data cleaned"
    else
      echo "Cancelled"
    fi
    ;;
  url)
    echo "Coder Access URLs:"
    echo "  → Local: http://localhost:7080"
    if command -v tailscale &> /dev/null; then
      TAILSCALE_IP=$(tailscale ip -4 2>/dev/null)
      if [ -n "$TAILSCALE_IP" ]; then
        echo "  → Tailscale: http://$TAILSCALE_IP:7080"
      fi
    fi
    ;;
  *)
    echo "Coder Management Script"
    echo ""
    echo "Usage: $0 {command}"
    echo ""
    echo "Commands:"
    echo "  start       - Start Coder server"
    echo "  stop        - Stop Coder server"
    echo "  restart     - Restart Coder server"
    echo "  logs        - View Coder logs (follow mode)"
    echo "  logs-all    - View all container logs"
    echo "  status      - Show container status"
    echo "  update      - Update to latest version"
    echo "  clean       - Remove all data (destructive)"
    echo "  url         - Show access URLs"
    exit 1
    ;;
esac
