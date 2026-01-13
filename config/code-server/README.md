# Code-Server Setup

A dockerized VS Code instance accessible via browser on your iPad.

## Installation

This is automatically installed and configured via dotfiles. The setup includes:
- OrbStack (Docker replacement) via Brewfile
- Code-server configuration symlinked to `~/Projects/.code-server/`
- Shell aliases for easy management

## Quick Start

```bash
# Start code-server
code-server start

# Stop code-server  
code-server stop

# View logs
code-server logs

# Check status
code-server status

# Update to latest version
code-server update
```

## Configuration

- **Location**: `~/Projects/.code-server/` (symlinked from dotfiles)
- **Workspace**: Opens `/home/coder/projects` (mounted to `~/Projects`)
- **Port**: 8080 (accessible at http://localhost:8080)
- **Password**: Set in `docker-compose.yml` (change `your-secure-password-change-me`)

## Mounted Volumes

- `~/Projects` → `/home/coder/projects` (read-write)
- `~/dotfiles-macos` → `/home/coder/dotfiles` (read-only)
- `~/.ssh` → `/home/coder/.ssh` (read-only)
- `~/.gitconfig` → `/home/coder/.gitconfig` (read-only)

## Access from iPad

### Option 1: Cloudflare Tunnel (Recommended for remote access)

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

### Option 2: Tailscale VPN (Recommended for private access)

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

## First-Time Setup

1. **Set your password**:
   ```bash
   code ~/Projects/.code-server/docker-compose.yml
   # Change both PASSWORD and SUDO_PASSWORD values
   ```

2. **Start code-server**:
   ```bash
   code-server start
   ```

3. **Access locally**: Open http://localhost:8080 in your browser

4. **Setup remote access**: Choose Cloudflare Tunnel or Tailscale (see above)

## Auto-start on Boot (Optional)

Create a LaunchAgent to start on login:

```bash
# Create plist file at ~/Library/LaunchAgents/com.coder.docker.plist
# Then load it with:
launchctl load ~/Library/LaunchAgents/com.coder.docker.plist
```
