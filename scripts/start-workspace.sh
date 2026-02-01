#!/bin/bash
# Workspace startup script
# Launches Safari and IntelliJ IDEA for your development environment

set -e

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Starting Development Workspace${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Default workspace (can be overridden with argument)
WORKSPACE="${1:-work}"

echo -e "${YELLOW}Starting workspace: ${WORKSPACE}${NC}\n"

# Set profile based on workspace
case "$WORKSPACE" in
    work|w)
        WORKSPACE="work"
        echo -e "${GREEN}✓ Switching to work profile${NC}"
        source ~/.config/profiles/work.sh 2>/dev/null || true
        HOMEPAGE="https://www.google.com"  # Replace with your work homepage
        ;;
    labs|l)
        WORKSPACE="labs"
        echo -e "${GREEN}✓ Switching to labs profile${NC}"
        source ~/.config/profiles/labs.sh 2>/dev/null || true
        HOMEPAGE="https://www.google.com"  # Replace with your labs homepage
        ;;
    personal|p)
        WORKSPACE="personal"
        echo -e "${GREEN}✓ Switching to personal profile${NC}"
        source ~/.config/profiles/personal.sh 2>/dev/null || true
        HOMEPAGE="https://www.google.com"  # Replace with your personal homepage
        ;;
    *)
        echo -e "${YELLOW}Unknown workspace: ${WORKSPACE}, defaulting to work${NC}"
        WORKSPACE="work"
        source ~/.config/profiles/work.sh 2>/dev/null || true
        HOMEPAGE="https://www.google.com"
        ;;
esac

# Launch Safari with homepage
echo -e "${GREEN}✓ Opening Safari${NC}"
open -a "Safari" "$HOMEPAGE" 2>/dev/null || echo "Safari not found"

# Wait a moment for Safari to start
sleep 2

# Launch IntelliJ IDEA
echo -e "${GREEN}✓ Opening IntelliJ IDEA${NC}"
if [ -d "/Applications/IntelliJ IDEA.app" ]; then
    open -a "IntelliJ IDEA"
elif [ -d "/Applications/IntelliJ IDEA CE.app" ]; then
    open -a "IntelliJ IDEA CE"
else
    echo -e "${YELLOW}⚠ IntelliJ IDEA not found. Install it via Brewfile.${NC}"
fi

# Optional: Open VSCode as well
# echo -e "${GREEN}✓ Opening VSCode${NC}"
# open -a "Visual Studio Code" || echo "VSCode not found"

echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}  Workspace ready! Happy coding 🚀${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
