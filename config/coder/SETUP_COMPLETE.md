# ✅ Coder Setup Complete!

Your Coder installation has been integrated into your dotfiles-macos repository.

## 📁 What Was Created

```
config/coder/
├── .env                           # Your local config (not committed)
├── .env.example                   # Template for new setups
├── .gitignore                     # Ignores .env file
├── docker-compose.yml             # Coder + PostgreSQL setup
├── manage.sh                      # Management script
├── quickstart.sh                  # Quick start script
├── README.md                      # Full documentation
└── templates/
    └── docker-workspace/
        ├── main.tf                # Terraform template
        └── template.yaml          # Template metadata
```

## 🚀 Quick Start (3 commands)

```bash
# 1. Navigate to coder config
cd ~/dotfiles-macos/config/coder

# 2. Edit .env and set CODER_DB_PASSWORD
vim .env

# 3. Run quick start
./quickstart.sh
```

## 📝 Shell Aliases Added

These aliases have been added to `shell/aliases.zsh`:

```bash
coder-start      # Start Coder
coder-stop       # Stop Coder
coder-restart    # Restart Coder
coder-logs       # View logs
coder-status     # Check status
coder-url        # Show access URLs
```

**Activate aliases:**
```bash
source ~/.zshrc
# or
exec zsh
```

## 🎯 Next Steps

### 1. Start Coder

```bash
cd ~/dotfiles-macos/config/coder
./quickstart.sh
```

### 2. Create Admin Account

- Open http://localhost:7080
- Create your first admin user

### 3. Install Coder CLI

```bash
brew install coder
coder login http://localhost:7080
```

### 4. Install VS Code Extension

1. Open VS Code Desktop
2. Search for "Coder" in extensions
3. Install the official Coder extension
4. Click Coder icon in sidebar
5. Add deployment: http://localhost:7080
6. Authenticate

### 5. Create Your First Workspace

**Via Web UI:**
- Go to http://localhost:7080
- Click "Templates" → Use the "docker-workspace" template
- Click "Create Workspace"

**Via CLI:**
```bash
# Push the template
cd ~/dotfiles-macos/config/coder/templates/docker-workspace
coder templates push docker-workspace

# Create workspace
coder create my-workspace --template docker-workspace
```

**Via VS Code:**
- Click Coder icon
- Click "Create Workspace"
- Select template
- Wait for provisioning
- Click "Open in VS Code"

## 🌐 Remote Access (Optional)

### Option A: Tailscale (Recommended)

```bash
# Install
brew install --cask tailscale

# Get your Tailscale IP
tailscale ip -4

# Update .env
CODER_ACCESS_URL=http://[your-tailscale-ip]:7080

# Restart Coder
./manage.sh restart
```

Access from any device: `http://[tailscale-ip]:7080`

### Option B: Cloudflare Tunnel

```bash
# Install
brew install cloudflare/cloudflare/cloudflared

# Create tunnel
cloudflared tunnel login
cloudflared tunnel create coder
cloudflared tunnel route dns coder coder.yourdomain.com

# Update .env
CODER_ACCESS_URL=https://coder.yourdomain.com

# Restart Coder
./manage.sh restart
```

## 🔧 Customization

### Modify Template

Edit `templates/docker-workspace/main.tf` to customize:
- Base Docker image
- Installed packages
- Dotfiles integration
- Volume mounts
- Environment variables

### Add New Template

```bash
mkdir -p templates/my-template
# Create main.tf and template.yaml
coder templates push my-template
```

## 📚 Resources

- **README.md** - Complete documentation
- **Coder Docs** - https://coder.com/docs
- **VS Code Extension** - https://marketplace.visualstudio.com/items?itemName=coder.coder-remote
- **Template Examples** - https://github.com/coder/coder/tree/main/examples/templates

## 🐛 Troubleshooting

### Coder won't start
```bash
./manage.sh logs-all
```

### Can't connect from VS Code
1. Check `./manage.sh status`
2. Verify URL matches in VS Code
3. Re-authenticate

### Port 7080 in use
Edit `docker-compose.yml` and change port mapping

## ✨ You're All Set!

Run `./quickstart.sh` to begin!
