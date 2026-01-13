#!/bin/bash

# Bootstrap Script
# Sets up macOS system with necessary tools and configurations

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 macOS Bootstrap Starting${NC}\n"

# Check if running on macOS
if [[ ! "$OSTYPE" == "darwin"* ]]; then
	echo -e "${RED}Error: This script is for macOS only${NC}"
	exit 1
fi

# 1. Install Xcode Command Line Tools
if ! command -v xcode-select &>/dev/null; then
	echo -e "${YELLOW}Installing Xcode Command Line Tools...${NC}"
	xcode-select --install
	read -p "Press enter after Xcode CLT installation completes..."
else
	echo -e "${GREEN}✓ Xcode Command Line Tools already installed${NC}"
fi

# 2. Install Homebrew
if ! command -v brew &>/dev/null; then
	echo -e "${YELLOW}Installing Homebrew...${NC}"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo -e "${GREEN}✓ Homebrew already installed${NC}"
fi

# 3. Update Homebrew
echo -e "${YELLOW}Updating Homebrew...${NC}"
brew update
brew upgrade

# 4. Install packages from Brewfile
echo -e "${YELLOW}Installing packages from Brewfile...${NC}"
brew bundle

# 5. Create necessary directories
echo -e "${YELLOW}Creating configuration directories...${NC}"
mkdir -p ~/.config/{zsh,vscode,moonlight,sunshine,git/profiles}
mkdir -p ~/.ssh
mkdir -p ~/Work/{work,yourzoned}
mkdir -p ~/Personal
chmod 700 ~/.ssh

# 6. Install Oh My Zsh
if [[ ! -d ~/.oh-my-zsh ]]; then
	echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
	echo -e "${GREEN}✓ Oh My Zsh already installed${NC}"
fi

# 7. Install Powerlevel10k
if [[ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]]; then
	echo -e "${YELLOW}Installing Powerlevel10k theme...${NC}"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
else
	echo -e "${GREEN}✓ Powerlevel10k already installed${NC}"
fi

# 8. Set Zsh as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
	echo -e "${YELLOW}Setting Zsh as default shell...${NC}"
	sudo chsh -s /bin/zsh "$(whoami)"
else
	echo -e "${GREEN}✓ Zsh is already the default shell${NC}"
fi

# 9. Make scripts executable
echo -e "${YELLOW}Making scripts executable...${NC}"
chmod +x "$(dirname "$0")"/*.sh

echo -e "\n${GREEN}✓ Bootstrap complete!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Run 'p10k configure' to configure Powerlevel10k"
echo "  2. Run 'profile-switch.sh' to set your work profile"
echo "  3. Close and reopen your terminal"
echo "  4. Update git config with your emails in ~/.config/git/profiles/"
