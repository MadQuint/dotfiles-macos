#!/bin/bash
# Quick Start Script for Coder

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🚀 Coder Quick Start"
echo "===================="
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker/OrbStack first."
    exit 1
fi

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from template..."
    cp .env.example .env
    echo "⚠️  Please edit config/coder/.env and set a secure CODER_DB_PASSWORD"
    echo ""
fi

# Start Coder
echo "🔄 Starting Coder..."
docker compose up -d

echo ""
echo "⏳ Waiting for Coder to be ready..."
sleep 10

# Wait for health check
max_attempts=30
attempt=0
while [ $attempt -lt $max_attempts ]; do
    if curl -sf http://localhost:7080/healthz > /dev/null 2>&1; then
        echo "✅ Coder is ready!"
        break
    fi
    attempt=$((attempt + 1))
    echo -n "."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo ""
    echo "⚠️  Coder is taking longer than expected to start."
    echo "Check logs with: ./manage.sh logs"
    exit 1
fi

echo ""
echo "✨ Coder is now running!"
echo ""
echo "Next steps:"
echo "  1. Open http://localhost:7080 in your browser"
echo "  2. Create your first admin user account"
echo "  3. Install Coder CLI: brew install coder"
echo "  4. Install VS Code extension: Search 'Coder' in VS Code"
echo "  5. Login via CLI: coder login http://localhost:7080"
echo ""
echo "Management commands:"
echo "  • View logs:    ./manage.sh logs"
echo "  • Stop Coder:   ./manage.sh stop"
echo "  • Check status: ./manage.sh status"
echo ""
echo "📖 Read README.md for detailed instructions"
