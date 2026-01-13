#!/bin/bash

# Post-install configuration script
# Sets up user-specific details from environment variables

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Dotfiles Personal Configuration${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Check for .env file
if [[ -f .env ]]; then
	source .env
fi

# Function to prompt for input with default
prompt_for_value() {
	local var_name=$1
	local prompt_text=$2
	local default_value=${!var_name:-}

	if [[ -n "$default_value" ]]; then
		read -p "$prompt_text [$default_value]: " value
		value=${value:-$default_value}
	else
		read -p "$prompt_text: " value
		while [[ -z "$value" ]]; do
			echo -e "${RED}Error: This field is required${NC}"
			read -p "$prompt_text: " value
		done
	fi

	eval "$var_name='$value'"
}

# Get user information
echo -e "${YELLOW}User Configuration:${NC}"
prompt_for_value "USER_NAME" "Full name"
prompt_for_value "USER_EMAIL" "Email address"

# Ensure we have at least work profile email
prompt_for_value "WORK_EMAIL" "Work email (or press enter to skip)"

# Get optional profile information
echo -e "\n${YELLOW}Profile Configuration (optional - press enter to skip):${NC}"
read -p "Labs email: " LABS_EMAIL
read -p "Personal email: " PERSONAL_EMAIL

# Update git config
echo -e "\n${YELLOW}Updating Git Configuration...${NC}"
git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"
echo -e "${GREEN}✓ Global git config updated${NC}"

# Create/update profile configurations
PROFILES_DIR="$HOME/.config/profiles"
mkdir -p "$PROFILES_DIR"

echo -e "\n${YELLOW}Setting up Work Profiles...${NC}"

# Work profile
cat > "$PROFILES_DIR/work.sh" <<EOF
#!/bin/bash
export WORK_PROFILE="work"
export WORK_EMAIL="${WORK_EMAIL:-$USER_EMAIL}"
git config user.email "\${WORK_EMAIL}"
EOF
chmod +x "$PROFILES_DIR/work.sh"
echo -e "${GREEN}✓ Work profile configured${NC}"

# Labs profile (if provided)
if [[ -n "$LABS_EMAIL" ]]; then
	cat > "$PROFILES_DIR/labs.sh" <<EOF
#!/bin/bash
export WORK_PROFILE="labs"
export WORK_EMAIL="$LABS_EMAIL"
git config user.email "$LABS_EMAIL"
EOF
	chmod +x "$PROFILES_DIR/labs.sh"
	echo -e "${GREEN}✓ Labs profile configured${NC}"
fi

# Personal profile (if provided)
if [[ -n "$PERSONAL_EMAIL" ]]; then
	cat > "$PROFILES_DIR/personal.sh" <<EOF
#!/bin/bash
export WORK_PROFILE="personal"
export WORK_EMAIL="$PERSONAL_EMAIL"
git config user.email "$PERSONAL_EMAIL"
EOF
	chmod +x "$PROFILES_DIR/personal.sh"
	echo -e "${GREEN}✓ Personal profile configured${NC}"
fi

# Update profile.zsh with actual emails
cat > "$PROFILES_DIR/profile.zsh" <<'EOF'
# Profile switching function

profile() {
	case "$1" in
	w | work)
		[[ -f ~/.config/profiles/work.sh ]] && source ~/.config/profiles/work.sh
		echo "Switched to: work"
		;;
	l | labs)
		[[ -f ~/.config/profiles/labs.sh ]] && source ~/.config/profiles/labs.sh
		echo "Switched to: labs"
		;;
	p | personal)
		[[ -f ~/.config/profiles/personal.sh ]] && source ~/.config/profiles/personal.sh
		echo "Switched to: personal"
		;;
	list | ls)
		echo "Available profiles:"
		echo "  • w / work"
		[[ -f ~/.config/profiles/labs.sh ]] && echo "  • l / labs"
		[[ -f ~/.config/profiles/personal.sh ]] && echo "  • p / personal"
		;;
	current)
		echo "Current profile: ${WORK_PROFILE:-not set}"
		;;
	*)
		echo "Usage: profile {w|l|p|list|current}"
		;;
	esac
}
EOF

# Create .env template
cat > .env.example <<'EOF'
# User Configuration
USER_NAME=Your Name
USER_EMAIL=your.email@example.com

# Profile Emails
WORK_EMAIL=work@example.com
LABS_EMAIL=labs@example.com
PERSONAL_EMAIL=personal@example.com
EOF

# Save configuration to .env (local, not committed)
cat > .env <<EOF
# Auto-generated user configuration
USER_NAME=$USER_NAME
USER_EMAIL=$USER_EMAIL
WORK_EMAIL=${WORK_EMAIL:-$USER_EMAIL}
LABS_EMAIL=$LABS_EMAIL
PERSONAL_EMAIL=$PERSONAL_EMAIL
EOF

chmod 600 .env

echo -e "\n${GREEN}✅ Configuration Complete!${NC}\n"
echo -e "${YELLOW}Next Steps:${NC}"
echo "  1. Configure Powerlevel10k: ${BLUE}p10k configure${NC}"
echo "  2. Switch to your work profile: ${BLUE}profile w${NC}"
echo "  3. Verify git config: ${BLUE}git config --list | grep user${NC}"
echo ""
echo -e "${YELLOW}Profile Management:${NC}"
echo "  • Switch profiles: ${BLUE}profile w${NC} (or l, p)"
echo "  • List available: ${BLUE}profile list${NC}"
echo "  • View current: ${BLUE}profile current${NC}"
echo ""
echo -e "${YELLOW}📝 Note:${NC} Configuration saved to .env (local, not committed)"
