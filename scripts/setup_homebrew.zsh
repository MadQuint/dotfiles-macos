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

# Install Homebrew Mac App Store (MAS) CLI
brew install mas

# Install Xcode and accept the license for other brew installations to work
# Install Xcode command-line tools if not installed
mas 'Xcode', id: 497799835
if ! xcode-select -p &> /dev/null
then
    echo "Installing Xcode command-line tools..."
    xcode-select --install
fi

if ! /usr/bin/xcrun clang &> /dev/null
then
    echo "Accepting Xcode license..."
    sudo xcodebuild -license accept
else
    echo "Xcode license already accepted."
fi

# Change to the script's directory (repo folder) 
cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install Homebrew Bundle
brew bundle --verbose