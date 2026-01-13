#!/bin/bash

# Install Brewfile
# Installs all packages defined in Brewfile

set -e

# Color output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Installing Homebrew packages from Brewfile...${NC}"

# Check if Homebrew is installed
if ! command -v brew &>/dev/null; then
	echo "Error: Homebrew is not installed"
	exit 1
fi

# Install from Brewfile
cd "$(dirname "$0")/.."
brew bundle --verbose

echo -e "${GREEN}✓ Brewfile installation complete!${NC}"
