#!/bin/bash
# Coder configuration script
# Automatically configures Coder with user-specific settings

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODER_DIR="$SCRIPT_DIR/../config/coder"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Coder Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check if .env exists in root dotfiles
if [[ -f "$SCRIPT_DIR/../.env" ]]; then
    source "$SCRIPT_DIR/../.env"
fi

# Check if coder/.env already exists
if [[ -f "$CODER_DIR/.env" ]]; then
    echo -e "${GREEN}✓ Coder .env already exists${NC}"
    read -p "Do you want to reconfigure? (y/N): " reconfigure
    if [[ ! "$reconfigure" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}Skipping Coder configuration${NC}"
        exit 0
    fi
fi

echo -e "${YELLOW}Coder Security Configuration:${NC}\n"

# Generate or prompt for database password
if [[ -n "$CODER_DB_PASSWORD" ]]; then
    echo -e "${GREEN}✓ Using existing CODER_DB_PASSWORD from .env${NC}"
    DB_PASSWORD="$CODER_DB_PASSWORD"
else
    echo "Generate a secure database password for Coder PostgreSQL"
    read -p "Auto-generate password? (Y/n): " auto_gen
    if [[ ! "$auto_gen" =~ ^[Nn]$ ]]; then
        DB_PASSWORD=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-25)
        echo -e "${GREEN}✓ Generated secure password${NC}"
    else
        read -sp "Enter database password: " DB_PASSWORD
        echo
        while [[ ${#DB_PASSWORD} -lt 12 ]]; do
            echo -e "${RED}Password must be at least 12 characters${NC}"
            read -sp "Enter database password: " DB_PASSWORD
            echo
        done
    fi
fi

# Determine access URL
echo -e "\n${YELLOW}Access Configuration:${NC}"
echo "1) Local only (localhost:7080)"
echo "2) Tailscale network"
echo "3) Custom URL"
read -p "Choose access method [1-3] (default: 1): " access_choice
access_choice=${access_choice:-1}

case $access_choice in
    1)
        ACCESS_URL="http://localhost:7080"
        echo -e "${GREEN}✓ Using local access${NC}"
        ;;
    2)
        if command -v tailscale &> /dev/null; then
            TAILSCALE_IP=$(tailscale ip -4 2>/dev/null || echo "")
            if [[ -n "$TAILSCALE_IP" ]]; then
                ACCESS_URL="http://$TAILSCALE_IP:7080"
                echo -e "${GREEN}✓ Using Tailscale IP: $TAILSCALE_IP${NC}"
            else
                echo -e "${YELLOW}⚠ Tailscale not connected, using localhost${NC}"
                ACCESS_URL="http://localhost:7080"
            fi
        else
            echo -e "${YELLOW}⚠ Tailscale not installed, using localhost${NC}"
            ACCESS_URL="http://localhost:7080"
        fi
        ;;
    3)
        read -p "Enter custom URL (e.g., https://coder.example.com): " ACCESS_URL
        ;;
esac

# Create .env file
echo -e "\n${BLUE}Creating Coder .env file...${NC}"
cat > "$CODER_DIR/.env" << EOF
# Coder Database Password
# Generated on $(date)
CODER_DB_PASSWORD=$DB_PASSWORD

# Coder Access URL
# This is how you and others will access Coder
CODER_ACCESS_URL=$ACCESS_URL

# Optional: Uncomment and configure if needed
# CODER_OIDC_ISSUER_URL=
# CODER_OIDC_CLIENT_ID=
# CODER_OIDC_CLIENT_SECRET=
EOF

echo -e "${GREEN}✓ Coder .env created successfully${NC}"

# Save to root .env if it doesn't exist there
if [[ ! -f "$SCRIPT_DIR/../.env" ]] || ! grep -q "CODER_DB_PASSWORD" "$SCRIPT_DIR/../.env"; then
    echo -e "\n${BLUE}Saving to root .env for future reference...${NC}"
    cat >> "$SCRIPT_DIR/../.env" << EOF

# Coder Configuration
CODER_DB_PASSWORD=$DB_PASSWORD
CODER_ACCESS_URL=$ACCESS_URL
EOF
    echo -e "${GREEN}✓ Saved to root .env${NC}"
fi

# Check if Docker is running
echo -e "\n${BLUE}Checking Docker...${NC}"
if docker info > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Docker is running${NC}\n"
    
    read -p "Start Coder now? (Y/n): " start_now
    if [[ ! "$start_now" =~ ^[Nn]$ ]]; then
        echo -e "\n${BLUE}Starting Coder...${NC}"
        cd "$CODER_DIR"
        docker compose up -d
        
        echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}✅ Coder is starting up!${NC}"
        echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
        echo -e "Access Coder at: ${BLUE}$ACCESS_URL${NC}\n"
        echo "Next steps:"
        echo "  1. Wait ~30 seconds for startup"
        echo "  2. Open $ACCESS_URL in your browser"
        echo "  3. Create your admin account"
        echo "  4. Install Coder CLI: brew install coder"
        echo "  5. Login: coder login $ACCESS_URL"
        echo -e "\nManagement commands:"
        echo "  • source ~/.zshrc && coder-status"
        echo "  • coder-logs"
        echo "  • coder-stop"
    fi
else
    echo -e "${YELLOW}⚠ Docker is not running${NC}"
    echo "Start Docker/OrbStack and run:"
    echo "  cd $CODER_DIR && ./quickstart.sh"
fi

echo -e "\n${GREEN}✓ Coder configuration complete!${NC}\n"
