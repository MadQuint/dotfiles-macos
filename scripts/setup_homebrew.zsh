#!/usr/bin/env zsh

# Check if Homebrew is installed
if ! command -v brew &> /dev/null
then
    # This installation method is necessary for Homebrew to install the correct versions of the software (silicon and not intel)  
    
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
else
    echo -e "\e[33mHomebrew is already installed. Skipping installation.\e[0m"
fi

# Install Homebrew Bundle
cd ~/.dotfiles
#brew bundle --verbose