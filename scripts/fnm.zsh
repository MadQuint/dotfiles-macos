#!/usr/bin/env zsh

# Check if fnm is installed
if ! command -v fnm &> /dev/null
then
    echo -e "\e[31mfnm could not be found, exiting...\e[0m"
    exit 1
fi 

# download and install Node.js
fnm use --install-if-missing 22

# verifies the right Node.js version is in the environment
node -v

# verifies the right NPM version is in the environment
npm -v