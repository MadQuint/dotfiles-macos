#!/bin/bash
# Coder Server Management Script
# Manages native Coder server (non-Docker)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODER_DATA_DIR="$SCRIPT_DIR/.data"
CODER_CONFIG_DIR="$SCRIPT_DIR"
CODER_PORT="${CODER_PORT:-7080}"
CODER_ACCESS_URL="${CODER_ACCESS_URL:-http://localhost:${CODER_PORT}}"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Ensure data directory exists
mkdir -p "$CODER_DATA_DIR"

show_usage() {
    echo -e "${BLUE}Coder Server Management${NC}\n"
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start       Start Coder server"
    echo "  stop        Stop Coder server"
    echo "  restart     Restart Coder server"
    echo "  status      Show Coder server status"
    echo "  logs        Show Coder server logs"
    echo "  url         Show Coder access URL"
    echo "  login       Login to Coder"
    echo "  templates   List workspace templates"
    echo ""
}

start_coder() {
    echo -e "${BLUE}Starting Coder Server...${NC}"
    
    # Check if already running
    if pgrep -f "coder server" > /dev/null; then
        echo -e "${YELLOW}⚠ Coder server is already running${NC}"
        echo -e "${GREEN}Access URL: ${CODER_ACCESS_URL}${NC}"
        return 0
    fi
    
    # Start Coder server in background
    export CODER_ACCESS_URL
    export CODER_DATA_DIR
    
    nohup coder server \
        --access-url "$CODER_ACCESS_URL" \
        --address "0.0.0.0:${CODER_PORT}" \
        --data-dir "$CODER_DATA_DIR" \
        > "$CODER_DATA_DIR/coder.log" 2>&1 &
    
    local pid=$!
    echo $pid > "$CODER_DATA_DIR/coder.pid"
    
    echo -e "${GREEN}✓ Coder server started (PID: $pid)${NC}"
    echo -e "${BLUE}Waiting for server to be ready...${NC}"
    
    # Wait for server to be ready
    for i in {1..30}; do
        if curl -sf "$CODER_ACCESS_URL/healthz" > /dev/null 2>&1; then
            echo -e "${GREEN}✓ Coder server is ready!${NC}"
            echo -e "${GREEN}Access URL: ${CODER_ACCESS_URL}${NC}"
            return 0
        fi
        sleep 1
    done
    
    echo -e "${YELLOW}⚠ Server started but health check timed out${NC}"
    echo -e "${YELLOW}Check logs: $0 logs${NC}"
}

stop_coder() {
    echo -e "${BLUE}Stopping Coder Server...${NC}"
    
    if [ -f "$CODER_DATA_DIR/coder.pid" ]; then
        local pid=$(cat "$CODER_DATA_DIR/coder.pid")
        if kill "$pid" 2>/dev/null; then
            echo -e "${GREEN}✓ Coder server stopped (PID: $pid)${NC}"
            rm -f "$CODER_DATA_DIR/coder.pid"
        else
            echo -e "${YELLOW}⚠ Process $pid not found, cleaning up${NC}"
            rm -f "$CODER_DATA_DIR/coder.pid"
        fi
    else
        # Try to find and kill by process name
        if pkill -f "coder server"; then
            echo -e "${GREEN}✓ Coder server stopped${NC}"
        else
            echo -e "${YELLOW}⚠ Coder server not running${NC}"
        fi
    fi
}

status_coder() {
    echo -e "${BLUE}Coder Server Status${NC}\n"
    
    if pgrep -f "coder server" > /dev/null; then
        local pid=$(pgrep -f "coder server")
        echo -e "${GREEN}● Coder server is running${NC}"
        echo -e "  PID: $pid"
        echo -e "  URL: ${CODER_ACCESS_URL}"
        echo -e "  Data: ${CODER_DATA_DIR}"
        
        # Check if accessible
        if curl -sf "$CODER_ACCESS_URL/healthz" > /dev/null 2>&1; then
            echo -e "  ${GREEN}✓ Health check: OK${NC}"
        else
            echo -e "  ${RED}✗ Health check: Failed${NC}"
        fi
    else
        echo -e "${RED}● Coder server is not running${NC}"
    fi
}

show_logs() {
    local log_file="$CODER_DATA_DIR/coder.log"
    
    if [ -f "$log_file" ]; then
        echo -e "${BLUE}Coder Server Logs (last 50 lines)${NC}\n"
        tail -50 "$log_file"
    else
        echo -e "${YELLOW}⚠ No log file found at: $log_file${NC}"
    fi
}

show_url() {
    echo -e "${GREEN}Coder Access URL:${NC}"
    echo "$CODER_ACCESS_URL"
    echo ""
    echo -e "${BLUE}From iPad/other devices on same network:${NC}"
    local_ip=$(ipconfig getifaddr en0 2>/dev/null || echo "unknown")
    echo "http://${local_ip}:${CODER_PORT}"
}

login_coder() {
    echo -e "${BLUE}Login to Coder${NC}\n"
    
    if ! pgrep -f "coder server" > /dev/null; then
        echo -e "${YELLOW}⚠ Coder server is not running${NC}"
        echo "Start it first: $0 start"
        return 1
    fi
    
    echo "Opening browser to: ${CODER_ACCESS_URL}"
    open "$CODER_ACCESS_URL"
    
    echo ""
    echo -e "${YELLOW}First-time setup:${NC}"
    echo "1. Create your admin account"
    echo "2. Login with your credentials"
    echo ""
}

list_templates() {
    echo -e "${BLUE}Workspace Templates${NC}\n"
    
    coder templates list 2>/dev/null || {
        echo -e "${YELLOW}⚠ Unable to list templates${NC}"
        echo "Make sure you're logged in: $0 login"
        return 1
    }
}

# Main command handler
case "${1:-}" in
    start)
        start_coder
        ;;
    stop)
        stop_coder
        ;;
    restart)
        stop_coder
        sleep 2
        start_coder
        ;;
    status)
        status_coder
        ;;
    logs)
        show_logs
        ;;
    url)
        show_url
        ;;
    login)
        login_coder
        ;;
    templates)
        list_templates
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
