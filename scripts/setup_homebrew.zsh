#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

# Clone Homebrew
cd /opt
sudo git clone https://github.com/Homebrew/brew homebrew

# Change ownership of the Homebrew directory
sudo chown -R $(whoami):staff /opt/homebrew

# Update new brew shellenv temporarily
eval "$(homebrew/bin/brew shellenv)"

# New brew update
brew update --force --quiet

# Make sure to remove other people's write permissions
chmod -R go-w "$(brew --prefix)/share/zsh"

# Add new bew shellenv
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Homebrew Bundle
cd ~/.dotfiles
# brew bundle --verbose