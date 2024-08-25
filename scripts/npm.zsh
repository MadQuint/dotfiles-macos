#!/usr/bin/env zsh

 # Check if pnpm is installed
if ! command -v npm &> /dev/null
then
    echo -e "\e[31mnpm could not be found, exiting...\e[0m"
    exit 1
fi

for package in "$@"
do
  if [[ ! -d "$HOME/.npm-global/lib/node_modules/$package" ]]
  then
    npm i -g --loglevel http $package
  else
    echo "- $package already installed, skipping"
  fi
done