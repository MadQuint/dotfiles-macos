# Code-Server Setup

A dockerized VS Code instance accessible via browser on your iPad.

## Quick Start

```bash
# Start code-server
~/Projects/.code-server/manage.sh start

# Stop code-server
~/Projects/.code-server/manage.sh stop

# View logs
~/Projects/.code-server/manage.sh logs

# Check status
~/Projects/.code-server/manage.sh status

# Update to latest version
~/Projects/.code-server/manage.sh update
```

## Configuration

- **Location**: `~/Projects/.code-server/`
- **Workspace**: Opens `/home/coder/projects` (mounted to `~/Projects`)
- **Port**: 8080 (accessible at http://localhost:8080)
- **Password**: Set in `docker-compose.yml` (change `your-secure-password-change-me`)

## Mounted Volumes

- `~/Projects` → `/home/coder/projects` (read-write)
- `~/dotfiles-macos` → `/home/coder/dotfiles` (read-only)
- `~/.ssh` → `/home/coder/.ssh` (read-only)
- `~/.gitconfig` → `/home/coder/.gitconfig` (read-only)

## Access Options

### 1. Cloudflare Tunnel

```bash
# Install cloudflared
brew install cloudflare/cloudflare/cloudflared

# Login and create tunnel
cloudflared tunnel login
cloudflared tunnel create code-server
cloudflared tunnel route dns code-server code.yourdomain.com

# Run tunnel
cloudflared tunnel --url http://localhost:8080 run code-server
```

### 2. Tailscale VPN

```bash
# Install tailscale
brew install --cask tailscale

# Start tailscale
open -a Tailscale

# Access via: http://[your-mac-tailscale-ip]:8080
```

## Dotfiles Integration

Your dotfiles are mounted read-only at `/home/coder/dotfiles`. To use them in the container:

1. Open terminal in code-server
2. Run your dotfiles setup script from within the container
3. Symlink configurations as needed

## Auto-start on Boot (Optional)

Create a LaunchAgent to start on login:

```bash
# Create plist file at ~/Library/LaunchAgents/com.coder.docker.plist
# Then load it with:
launchctl load ~/Library/LaunchAgents/com.coder.docker.plist
```
