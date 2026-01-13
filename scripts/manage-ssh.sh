#!/bin/bash

# SSH Key Management Script
# Stores SSH keys in macOS Keychain for secure access
# Keys can be backed up in private/ directory (gitignored)

set -e

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"
PRIVATE_DIR="$DOTFILES_DIR/private/ssh"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  SSH Key Management${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

# Function to generate new SSH key
generate_key() {
	local profile=$1
	local email=$2
	local keyfile="$HOME/.ssh/${profile}"

	echo -e "${YELLOW}Generating SSH key for profile: ${profile}${NC}"
	
	ssh-keygen -t ed25519 -C "$email" -f "$keyfile" -N ""
	
	# Add to SSH agent with macOS Keychain
	ssh-add --apple-use-keychain "$keyfile" 2>/dev/null || ssh-add -K "$keyfile"
	
	echo -e "${GREEN}✓ SSH key generated and added to macOS Keychain${NC}"
	echo -e "${YELLOW}Public key:${NC}"
	cat "${keyfile}.pub"
	echo ""
}

# Function to backup SSH key to private directory
backup_key() {
	local profile=$1
	local keyfile="$HOME/.ssh/${profile}"
	
	if [[ ! -f "$keyfile" ]]; then
		echo -e "${RED}Error: SSH key $keyfile not found${NC}"
		return 1
	fi
	
	mkdir -p "$PRIVATE_DIR"
	cp "$keyfile" "$PRIVATE_DIR/${profile}"
	cp "${keyfile}.pub" "$PRIVATE_DIR/${profile}.pub"
	
	echo -e "${GREEN}✓ SSH key backed up to private/ssh/${profile}${NC}"
	echo -e "${YELLOW}⚠️  Remember: private/ is gitignored for security${NC}"
}

# Function to restore SSH key from private directory
restore_key() {
	local profile=$1
	local backup_file="$PRIVATE_DIR/${profile}"
	
	if [[ ! -f "$backup_file" ]]; then
		echo -e "${RED}Error: Backup key $backup_file not found${NC}"
		return 1
	fi
	
	mkdir -p "$HOME/.ssh"
	cp "$backup_file" "$HOME/.ssh/${profile}"
	cp "${backup_file}.pub" "$HOME/.ssh/${profile}.pub"
	chmod 600 "$HOME/.ssh/${profile}"
	chmod 644 "$HOME/.ssh/${profile}.pub"
	
	# Add to SSH agent with macOS Keychain
	ssh-add --apple-use-keychain "$HOME/.ssh/${profile}" 2>/dev/null || ssh-add -K "$HOME/.ssh/${profile}"
	
	echo -e "${GREEN}✓ SSH key restored and added to macOS Keychain${NC}"
}

# Function to add existing key to Keychain
add_to_keychain() {
	local profile=$1
	local keyfile="$HOME/.ssh/${profile}"
	
	if [[ ! -f "$keyfile" ]]; then
		echo -e "${RED}Error: SSH key $keyfile not found${NC}"
		return 1
	fi
	
	# Add to SSH agent with macOS Keychain
	ssh-add --apple-use-keychain "$keyfile" 2>/dev/null || ssh-add -K "$keyfile"
	
	echo -e "${GREEN}✓ SSH key added to macOS Keychain${NC}"
}

# Function to list SSH keys
list_keys() {
	echo -e "${YELLOW}SSH keys in ~/.ssh/:${NC}"
	ls -la ~/.ssh/*.pub 2>/dev/null | awk '{print "  " $9}' || echo "  No SSH keys found"
	echo ""
	
	echo -e "${YELLOW}Keys in SSH agent:${NC}"
	ssh-add -l 2>/dev/null || echo "  No keys in agent"
	echo ""
	
	if [[ -d "$PRIVATE_DIR" ]]; then
		echo -e "${YELLOW}Backed up keys in private/:${NC}"
		ls -1 "$PRIVATE_DIR"/*.pub 2>/dev/null | xargs -n1 basename | sed 's/.pub$//' | sed 's/^/  /' || echo "  No backups"
	fi
}

# Update SSH config for macOS Keychain
setup_ssh_config() {
	local ssh_config="$HOME/.ssh/config"
	
	mkdir -p "$HOME/.ssh"
	
	# Check if config already has the macOS Keychain settings
	if ! grep -q "UseKeychain yes" "$ssh_config" 2>/dev/null; then
		echo -e "${YELLOW}Updating SSH config for macOS Keychain...${NC}"
		
		cat >> "$ssh_config" <<'EOF'

# macOS Keychain Integration
Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentitiesOnly yes

EOF
		echo -e "${GREEN}✓ SSH config updated${NC}"
	else
		echo -e "${GREEN}✓ SSH config already configured${NC}"
	fi
}

# Main menu
show_menu() {
	echo -e "${YELLOW}Options:${NC}"
	echo "  1) Generate new SSH key"
	echo "  2) Backup SSH key to private/"
	echo "  3) Restore SSH key from private/"
	echo "  4) Add existing key to macOS Keychain"
	echo "  5) List all SSH keys"
	echo "  6) Setup SSH config for macOS Keychain"
	echo "  7) Exit"
	echo ""
}

# Main logic
if [[ $# -eq 0 ]]; then
	while true; do
		show_menu
		read -p "Select option: " choice
		
		case $choice in
			1)
				read -p "Profile name (e.g., work, labs, personal): " profile
				read -p "Email address: " email
				generate_key "$profile" "$email"
				read -p "Backup this key to private/? (y/n): " backup
				if [[ "$backup" == "y" ]]; then
					backup_key "$profile"
				fi
				;;
			2)
				read -p "Profile name to backup: " profile
				backup_key "$profile"
				;;
			3)
				read -p "Profile name to restore: " profile
				restore_key "$profile"
				;;
			4)
				read -p "Profile name: " profile
				add_to_keychain "$profile"
				;;
			5)
				list_keys
				;;
			6)
				setup_ssh_config
				;;
			7)
				exit 0
				;;
			*)
				echo -e "${RED}Invalid option${NC}"
				;;
		esac
		echo ""
	done
else
	# Command line usage
	case "$1" in
		generate)
			generate_key "$2" "$3"
			;;
		backup)
			backup_key "$2"
			;;
		restore)
			restore_key "$2"
			;;
		add)
			add_to_keychain "$2"
			;;
		list)
			list_keys
			;;
		setup-config)
			setup_ssh_config
			;;
		*)
			echo "Usage: $0 {generate|backup|restore|add|list|setup-config}"
			echo ""
			echo "Interactive mode: $0 (no arguments)"
			echo ""
			echo "Examples:"
			echo "  $0 generate work user@work.com"
			echo "  $0 backup work"
			echo "  $0 restore work"
			echo "  $0 add work"
			echo "  $0 list"
			echo "  $0 setup-config"
			exit 1
			;;
	esac
fi
