# Coder Setup

A self-hosted Coder deployment using Docker Compose, integrated with VS Code Desktop via the Coder extension.

## What is Coder?

Coder is an open-source platform for provisioning remote development workspaces. Unlike code-server (browser-based VS Code), Coder lets you use your local VS Code Desktop to connect to remote development environments.

## Quick Start

### 1. Initial Setup

```bash
# Create environment file
cd ~/dotfiles-macos/config/coder
cp .env.example .env
# Edit .env and set a secure CODER_DB_PASSWORD
vim .env

# Start Coder
./manage.sh start
```

### 2. First-Time Configuration

1. Open http://localhost:7080 in your browser
2. Create your first admin user account
3. You'll be taken to the Coder dashboard

### 3. Install Coder CLI

```bash
# macOS installation
brew install coder

# Login to your Coder instance
coder login http://localhost:7080
```

### 4. Install VS Code Extension

1. Open VS Code Desktop
2. Install the "Coder" extension from the marketplace
3. Click the Coder icon in the sidebar
4. Add your Coder deployment URL: http://localhost:7080
5. Authenticate when prompted

## Management Commands

```bash
# Start Coder
./manage.sh start

# Stop Coder
./manage.sh stop

# Restart Coder
./manage.sh restart

# View logs
./manage.sh logs

# Check status
./manage.sh status

# Update to latest version
./manage.sh update

# Show access URLs
./manage.sh url

# Clean all data (destructive)
./manage.sh clean
```

## Creating Your First Workspace

### Using the Web UI

1. Go to http://localhost:7080
2. Click "Templates" → "Create Template"
3. Choose a starter template (Docker, Kubernetes, etc.)
4. Click "Create Workspace"
5. Your workspace will be provisioned

### Using VS Code Extension

1. Open VS Code Desktop
2. Click the Coder icon in the sidebar
3. Click "Create Workspace"
4. Choose a template
5. Once ready, click "Open in VS Code"

### Using CLI

```bash
# List available templates
coder templates list

# Create a workspace
coder create my-workspace --template=docker

# SSH into workspace
coder ssh my-workspace

# Open in VS Code
coder code my-workspace
```

## Workspace Templates

Coder uses Terraform templates to provision workspaces. Here's a simple Docker-based template:

### Basic Docker Template

Create `~/dotfiles-macos/config/coder/templates/docker-workspace/main.tf`:

```hcl
terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "coder" {}
provider "docker" {}

data "coder_workspace" "me" {}

resource "coder_agent" "main" {
  os   = "linux"
  arch = "amd64"
  startup_script = <<-EOT
    #!/bin/bash
    # Install dotfiles
    if [ ! -d ~/dotfiles-macos ]; then
      git clone https://github.com/yourusername/dotfiles-macos.git ~/dotfiles-macos
      cd ~/dotfiles-macos && ./install
    fi
  EOT
}

resource "docker_container" "workspace" {
  image = "codercom/enterprise-base:ubuntu"
  name  = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}"
  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
  ]
  volumes {
    container_path = "/home/coder"
    volume_name    = docker_volume.home.name
  }
}

resource "docker_volume" "home" {
  name = "coder-${data.coder_workspace.me.owner}-${data.coder_workspace.me.name}-home"
}
```

## Shell Aliases Integration

Add to your `~/dotfiles-macos/shell/aliases.zsh`:

```bash
# Coder aliases
alias coder-start='~/dotfiles-macos/config/coder/manage.sh start'
alias coder-stop='~/dotfiles-macos/config/coder/manage.sh stop'
alias coder-logs='~/dotfiles-macos/config/coder/manage.sh logs'
alias coder-status='~/dotfiles-macos/config/coder/manage.sh status'
```

Then reload your shell:
```bash
source ~/.zshrc
```

## Remote Access Options

### Option 1: Tailscale VPN (Recommended)

```bash
# Install Tailscale
brew install --cask tailscale

# Start Tailscale and login
open -a Tailscale

# Get your Tailscale IP
tailscale ip -4

# Access Coder from any device on your Tailscale network
# Use: http://[your-tailscale-ip]:7080
```

Update `.env`:
```bash
CODER_ACCESS_URL=http://[your-tailscale-ip]:7080
```

### Option 2: Cloudflare Tunnel

```bash
# Install cloudflared
brew install cloudflare/cloudflare/cloudflared

# Login and create tunnel
cloudflared tunnel login
cloudflared tunnel create coder
cloudflared tunnel route dns coder coder.yourdomain.com

# Configure tunnel
cat > ~/.cloudflared/config.yml <<EOF
tunnel: coder
credentials-file: /Users/gianni/.cloudflared/[tunnel-id].json

ingress:
  - hostname: coder.yourdomain.com
    service: http://localhost:7080
  - service: http_status:404
EOF

# Run tunnel
cloudflared tunnel run coder
```

Update `.env`:
```bash
CODER_ACCESS_URL=https://coder.yourdomain.com
```

## Integration with Dotfiles

Your workspaces can automatically set up your dotfiles:

1. Add your dotfiles repo URL in workspace creation
2. Or include in template startup script:

```bash
git clone https://github.com/yourusername/dotfiles-macos.git ~/dotfiles
cd ~/dotfiles && ./install
```

## Architecture

```
┌─────────────────┐
│  VS Code Desktop│
│   (Your Mac)    │
└────────┬────────┘
         │ Coder Extension
         │
┌────────▼────────┐
│  Coder Server   │◄──── Docker Compose
│  localhost:7080 │      (PostgreSQL DB)
└────────┬────────┘
         │
    ┌────▼────┐
    │Workspace│
    │Container│
    └─────────┘
```

## Troubleshooting

### Coder not starting

Check logs:
```bash
./manage.sh logs-all
```

### Database connection issues

Reset database:
```bash
./manage.sh stop
docker volume rm coder_coder-postgres-data
./manage.sh start
```

### VS Code extension can't connect

1. Verify Coder is running: `./manage.sh status`
2. Check access URL in VS Code matches your deployment
3. Re-authenticate in VS Code

### Port conflicts

If port 7080 is in use, edit `docker-compose.yml`:
```yaml
ports:
  - "7081:7080"  # Change 7080 to 7081
```

Update CODER_ACCESS_URL accordingly.

## Resources

- [Coder Documentation](https://coder.com/docs)
- [Coder VS Code Extension](https://marketplace.visualstudio.com/items?itemName=coder.coder-remote)
- [Coder CLI](https://coder.com/docs/cli)
- [Template Examples](https://github.com/coder/coder/tree/main/examples/templates)

## Comparison: Coder vs code-server

| Feature | Coder | code-server |
|---------|-------|-------------|
| Interface | VS Code Desktop | Browser |
| Multi-workspace | ✅ Yes | ❌ No |
| Templates | ✅ Yes | ❌ No |
| Team Management | ✅ Yes | ❌ No |
| Local Extensions | ✅ Yes | ❌ Limited |
| Offline Work | ✅ Yes | ❌ No |

## Next Steps

1. ✅ Start Coder: `./manage.sh start`
2. ✅ Create admin account at http://localhost:7080
3. ✅ Install Coder CLI: `brew install coder`
4. ✅ Install VS Code extension: Search "Coder" in VS Code
5. ✅ Create your first workspace template
6. ✅ Connect VS Code Desktop to your workspace
7. ✅ (Optional) Set up Tailscale for remote access
