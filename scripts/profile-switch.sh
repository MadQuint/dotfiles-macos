#!/bin/bash

# Profile Switcher Script
# Allows switching between work, Yourzoned, and Personal profiles
# Updates shell environment variables and git configurations

set -e

PROFILE_DIR="$HOME/.config/profiles"
CURRENT_PROFILE_FILE="$HOME/.profile.current"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Available profiles
PROFILES=("work" "yourzoned" "personal")

# Function to show available profiles
show_profiles() {
	echo -e "${YELLOW}Available profiles:${NC}"
	for i in "${!PROFILES[@]}"; do
		echo "  $((i + 1))) ${PROFILES[$i]}"
	done
}

# Function to switch profile
switch_profile() {
	local profile=$1

	# Validate profile
	if [[ ! " ${PROFILES[@]} " =~ " ${profile} " ]]; then
		echo -e "${RED}Error: Unknown profile '${profile}'${NC}"
		show_profiles
		return 1
	fi

	# Create profile directory if it doesn't exist
	mkdir -p "$PROFILE_DIR"

	# Save current profile
	echo "$profile" >"$CURRENT_PROFILE_FILE"

	# Source profile-specific settings
	if [[ -f "$PROFILE_DIR/${profile}.sh" ]]; then
		source "$PROFILE_DIR/${profile}.sh"
	fi

	# Update git config
	git config user.email "gianni@${profile}.com"

	echo -e "${GREEN}✓ Switched to profile: ${profile}${NC}"

	# Export for current shell session
	export WORK_PROFILE="$profile"
}

# Function to show current profile
show_current() {
	if [[ -f "$CURRENT_PROFILE_FILE" ]]; then
		local current_profile=$(<"$CURRENT_PROFILE_FILE")
		echo -e "${GREEN}Current profile: ${current_profile}${NC}"
	else
		echo -e "${YELLOW}No profile set${NC}"
	fi
}

# Main logic
case "${1:-}" in
"")
	show_current
	;;
"list" | "-l" | "--list")
	show_profiles
	;;
"current" | "-c" | "--current")
	show_current
	;;
"switch" | "-s" | "--switch")
	if [[ -z "$2" ]]; then
		show_profiles
		read -p "Enter profile number or name: " selection
		if [[ "$selection" =~ ^[0-9]+$ ]]; then
			selection=$((selection - 1))
			if [[ $selection -ge 0 && $selection -lt ${#PROFILES[@]} ]]; then
				switch_profile "${PROFILES[$selection]}"
			else
				echo -e "${RED}Invalid selection${NC}"
				return 1
			fi
		else
			switch_profile "$selection"
		fi
	else
		switch_profile "$2"
	fi
	;;
*)
	switch_profile "$1"
	;;
esac
