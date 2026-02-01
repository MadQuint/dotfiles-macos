# Coder Configuration (Native - No Docker)

Coder server running natively on macOS with local workspace templates.

## Overview

This setup runs Coder **natively** on your Mac - no Docker containers needed. Workspaces are created as local directories on your filesystem, giving you:

- ✅ **Direct filesystem access** - No volume mounts or container overhead
- ✅ **Native performance** - Full Mac hardware utilization
- ✅ **iPad access** - Manage workspaces from your iPad via browser
- ✅ **IntelliJ integration** - One-click open in IntelliJ IDEA
- ✅ **Multi-profile support** - Work and Labs profiles

## Quick Start

### 1. Install Coder (if not already installed)

```bash
brew install coder
```

### 2. Run Setup

```bash
cd ~/.dotfiles/config/coder
./setup.sh
```

This will:
- Start Coder server on port 7080
- Create your admin account
- Import workspace templates (IntelliJ, General)
- Show you next steps

### 3. Create Your First Workspace

```bash
# IntelliJ workspace for Java
coder create my-java-project --template=intellij-workspace

# General workspace for Node.js/Python/Web
coder create my-web-project --template=general-workspace
```

## Management Commands

```bash
# Server management
coder-start         # Start Coder server
coder-stop          # Stop Coder server
coder-restart       # Restart Coder server
coder-status        # Check server status
coder-logs          # View server logs
coder-url           # Show access URLs
coder-login         # Login to Coder

# Workspace management
coder list          # List all workspaces
coder create        # Create new workspace
coder delete        # Delete workspace
coder open          # Open workspace app
coder ssh           # SSH into workspace
```

## Available Templates

### IntelliJ Workspace

For Java/Kotlin development with IntelliJ IDEA.

**Features:**
- Java/OpenJDK (11, 17, or 21)
- IntelliJ IDEA integration
- Git initialization
- VSCode fallback
- Terminal access

**Create:**
```bash
coder create my-java-app --template=intellij-workspace \
  --parameter project_name=my-java-app \
  --parameter java_version=21
```

**Open in IntelliJ:**
```bash
coder open my-java-app --app intellij
```

### General Workspace

For Node.js, Python, Web development.

**Features:**
- Node.js via fnm
- Python support
- Git initialization
- VSCode integration
- Terminal access

**Create:**
```bash
coder create my-web-app --template=general-workspace \
  --parameter project_name=my-web-app
```

## Access from iPad

1. Ensure your Mac and iPad are on the same network
2. Get your Mac's IP address:
   ```bash
   coder-url
   ```
3. Open Safari on iPad and navigate to the URL shown (e.g., `http://192.168.1.x:7080`)
4. Login with your Coder credentials
5. Create and manage workspaces from the web UI

**Note:** IntelliJ IDEA requires the desktop app, so from iPad you can:
- Use the web-based code editor
- Manage workspaces (create, delete, configure)
- Access terminal via web
- Use VSCode web interface (if configured)

## Workspace Structure

All workspaces are created under:

```
~/Workspaces/
└── {username}/
    ├── my-java-project/
    │   ├── .git/
    │   ├── .gitignore
    │   └── src/
    └── my-web-project/
        ├── .git/
        ├── .gitignore
        └── ...
```

## Integration with Profiles

Coder works with your dotfiles profiles:

```bash
# Switch to work profile
profile work

# Start Coder server
coder-start

# Create work workspace
coder create work-project --template=intellij-workspace

# Open in IntelliJ
coder open work-project --app intellij
```

Your work profile's git config will be active in all workspaces.

## Auto-Start (Optional)

To start Coder automatically on login, create a LaunchAgent:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.user.coder</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Users/YOUR_USERNAME/dotfiles-macos/config/coder/manage.sh</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>StandardOutPath</key>
    <string>/tmp/coder-launch.log</string>
    <key>StandardErrorPath</key>
    <string>/tmp/coder-launch-error.log</string>
</dict>
</plist>
```

Save to `~/Library/LaunchAgents/com.user.coder.plist` and load:

```bash
launchctl load ~/Library/LaunchAgents/com.user.coder.plist
```

## Troubleshooting

### Server won't start

```bash
# Check if port is already in use
lsof -i :7080

# View logs
coder-logs
```

### Can't login

```bash
# Restart server
coder-restart

# Try logging in again
coder-login
```

### Template import fails

```bash
# Ensure you're in the coder directory
cd ~/.dotfiles/config/coder

# Manually push template
cd templates/intellij-workspace
coder templates push intellij-workspace --directory . --yes
```

### iPad can't connect

- Ensure Mac and iPad are on same network
- Check firewall settings (System Settings > Network > Firewall)
- Try accessing via Mac's IP: `http://[mac-ip]:7080`

## Architecture

```
┌─────────────────────────────────────────┐
│         macOS (Native)                  │
│                                         │
│  ┌───────────────────────────────────┐ │
│  │   Coder Server (Port 7080)        │ │
│  │   ~/.dotfiles/config/coder/.data/ │ │
│  └──────────┬────────────────────────┘ │
│             │                           │
│  ┌──────────▼────────────────────────┐ │
│  │   Workspace Templates             │ │
│  │   - intellij-workspace            │ │
│  │   - general-workspace             │ │
│  └──────────┬────────────────────────┘ │
│             │                           │
│  ┌──────────▼────────────────────────┐ │
│  │   Workspaces                      │ │
│  │   ~/Workspaces/{user}/{project}/  │ │
│  │   - Native filesystem             │ │
│  │   - Direct access                 │ │
│  └───────────────────────────────────┘ │
└─────────────────────────────────────────┘
            │
            │ HTTP :7080
            │
    ┌───────▼───────┐
    │  iPad/Browser │
    │  Safari       │
    └───────────────┘
```

## Resources

- [Coder Documentation](https://coder.com/docs)
- [Terraform Provider](https://registry.terraform.io/providers/coder/coder/latest/docs)
- Templates: `~/.dotfiles/config/coder/templates/`
