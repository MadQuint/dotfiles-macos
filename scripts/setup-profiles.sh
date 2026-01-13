#!/bin/bash

# Setup profiles script
# Creates profile-specific configuration files

set -e

PROFILES_DIR="$HOME/.config/profiles"
mkdir -p "$PROFILES_DIR"

# Create profile environment files
create_profile() {
	local profile=$1
	local email=$2
	local ssh_key=$3

	cat >"$PROFILES_DIR/${profile}.sh" <<EOF
#!/bin/bash
# Profile: $profile

export WORK_PROFILE="$profile"
export WORK_EMAIL="$email"
export WORK_SSH_KEY="$ssh_key"

# Set git config for this profile
git config user.email "$email"

# Optional: Source profile-specific aliases
if [[ -f "$PROFILES_DIR/${profile}.aliases" ]]; then
	source "$PROFILES_DIR/${profile}.aliases"
fi
EOF
	chmod +x "$PROFILES_DIR/${profile}.sh"
}

echo "Setting up work profiles..."

# Create work profile
create_profile "work" "gianni@work.com" "~/.ssh/work"
cat >"$PROFILES_DIR/work.aliases" <<'EOF'
# Work specific aliases
alias w-dev="cd ~/Work && pwd"
EOF

# Create Yourzoned profile
create_profile "yourzoned" "gianni@yourzoned.com" "~/.ssh/yourzoned"
cat >"$PROFILES_DIR/yourzoned.aliases" <<'EOF'
# Yourzoned specific aliases
alias yz-dev="cd ~/Work/yourzoned && pwd"
EOF

# Create Personal profile
create_profile "personal" "gianni@personal.com" "~/.ssh/personal"
cat >"$PROFILES_DIR/personal.aliases" <<'EOF'
# Personal specific aliases
alias p-dev="cd ~/Personal && pwd"
EOF

# Create a shell function for easy profile switching
cat >"$PROFILES_DIR/profile.zsh" <<'EOF'
# Add to ~/.zshrc to enable profile switching

profile() {
	case "$1" in
	w | work)
		source ~/.config/profiles/work.sh
		;;
	yz | yourzoned)
		source ~/.config/profiles/yourzoned.sh
		;;
	p | personal)
		source ~/.config/profiles/personal.sh
		;;
	list | ls)
		echo "Available profiles:"
		echo "  • w / work"
		echo "  • yz / yourzoned"
		echo "  • p / personal"
		;;
	current)
		echo "Current profile: ${WORK_PROFILE:-none}"
		;;
	*)
		echo "Usage: profile {w|yz|p|list|current}"
		;;
	esac
}
EOF

echo "✓ Profiles configured successfully!"
echo ""
echo "To switch profiles, add this to your ~/.zshrc:"
echo "  source ~/.config/profiles/profile.zsh"
echo ""
echo "Then use:"
echo "  profile w         # Switch to Work"
echo "  profile yz        # Switch to Yourzoned"
echo "  profile p         # Switch to Personal"
echo "  profile list      # List available profiles"
echo "  profile current   # Show current profile"
