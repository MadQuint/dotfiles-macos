#!/bin/bash
# Coder Quick Setup Script
# Sets up Coder server and imports templates

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Coder Setup & Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check if Coder is installed
if ! command -v coder &> /dev/null; then
    echo -e "${RED}✗ Coder is not installed${NC}"
    echo "Install it with: brew install coder"
    exit 1
fi

echo -e "${GREEN}✓ Coder is installed${NC}"

# Start Coder server
echo -e "\n${YELLOW}Starting Coder server...${NC}"
"$SCRIPT_DIR/manage.sh" start

# Wait for server to be fully ready
sleep 3

# Get the access URL
CODER_URL=$(grep CODER_ACCESS_URL "$SCRIPT_DIR/manage.sh" | grep -o 'http://[^"]*' | head -1)
export CODER_URL="${CODER_URL:-http://localhost:7080}"

echo -e "\n${YELLOW}Checking Coder authentication...${NC}"

# Check if already logged in
if coder login "$CODER_URL" --first-user-username admin --first-user-email admin@localhost --first-user-password admin 2>/dev/null; then
    echo -e "${GREEN}✓ Logged in to Coder${NC}"
else
    echo -e "${YELLOW}Setting up first user...${NC}"
    echo "Please complete the setup in your browser at: $CODER_URL"
    open "$CODER_URL"
    
    echo ""
    read -p "Press Enter after completing the web setup..."
    
    echo ""
    echo -e "${YELLOW}Now login with your credentials:${NC}"
    coder login "$CODER_URL"
fi

# Import templates
echo -e "\n${YELLOW}Importing workspace templates...${NC}"

for template_dir in "$TEMPLATES_DIR"/*; do
    if [ -d "$template_dir" ]; then
        template_name=$(basename "$template_dir")
        echo -e "\n${BLUE}Importing template: ${template_name}${NC}"
        
        cd "$template_dir"
        
        # Check if template already exists
        if coder templates list | grep -q "$template_name"; then
            echo -e "${YELLOW}Template already exists, updating...${NC}"
            coder templates push "$template_name" --directory . --yes
        else
            echo -e "${GREEN}Creating new template...${NC}"
            coder templates create "$template_name" --directory . --yes
        fi
    fi
done

cd "$SCRIPT_DIR"

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Setup Complete! 🎉${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "1. Access Coder UI:"
echo "   ${CODER_URL}"
echo ""
echo "2. Create a workspace:"
echo "   ${YELLOW}coder create my-project --template=intellij-workspace${NC}"
echo ""
echo "3. List your workspaces:"
echo "   ${YELLOW}coder list${NC}"
echo ""
echo "4. Open workspace in IntelliJ:"
echo "   ${YELLOW}coder open my-project --app intellij${NC}"
echo ""
echo "5. Access from iPad:"
echo "   http://$(ipconfig getifaddr en0 2>/dev/null || echo 'YOUR_IP'):7080"
echo ""
echo -e "${BLUE}Management commands:${NC}"
echo "   coder-status    # Check server status"
echo "   coder-stop      # Stop server"
echo "   coder-restart   # Restart server"
echo "   coder-logs      # View server logs"
echo "   coder-url       # Show access URLs"
echo ""
