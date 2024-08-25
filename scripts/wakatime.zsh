#!/usr/bin/env zsh

# Check if api key is set and has a value in the config file
if [[ -n $( grep "api_key" ~/.wakatime.cfg ) ]]
then
  echo -e "\e[33mThe api_key is already set in the .wakatime.cfg file.\e[0m"
  exit 0
fi

# Load the environment variables
source "$HOME/.dotfiles/env/tokens.zsh"

# Check if the WAKATIME_API_KEY environment variable is set
if [[ -z $WAKATIME_API_KEY ]]
then
  echo -e "\e[33mThe WAKATIME_API_KEY environment variable is not set.\e[0m"
  exit 1
fi

# Create or overwrite the .wakatime.cfg file
cat <<EOF > ~/.wakatime.cfg
[settings]
api_key = $WAKATIME_API_KEY
EOF

echo -e "\e[32m.wakatime.cfg file has been created with your API key.\e[0m"