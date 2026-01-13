# Coder vs code-server: What's the Difference?

You now have **both** in your dotfiles! Here's when to use each:

## 📊 Quick Comparison

| Feature | code-server | Coder |
|---------|-------------|-------|
| **Interface** | Browser | VS Code Desktop |
| **Port** | 8080 | 7080 |
| **Use Case** | iPad/Browser coding | Professional dev workspaces |
| **Workspaces** | Single environment | Multiple workspaces |
| **Templates** | ❌ No | ✅ Yes |
| **Team Features** | ❌ No | ✅ Yes |
| **Extensions** | Limited | Full support |
| **Offline Work** | ❌ No | ✅ Yes |

## 🎯 When to Use Each

### Use **code-server** when:
- ✅ Working from iPad/tablet
- ✅ Need quick browser access
- ✅ Simple, single project work
- ✅ Don't need local VS Code
- ✅ Want simplicity

**Location**: `~/dotfiles-macos/config/code-server/`

**Access**: http://localhost:8080

**Commands**:
```bash
code-server start
code-server stop
code-server logs
```

### Use **Coder** when:
- ✅ Want to use VS Code Desktop
- ✅ Need multiple dev environments
- ✅ Working on different projects
- ✅ Want reproducible workspaces
- ✅ Need team collaboration
- ✅ Want infrastructure as code

**Location**: `~/dotfiles-macos/config/coder/`

**Access**: http://localhost:7080

**Commands**:
```bash
coder-start
coder-stop
coder-logs
coder-status
```

## 💡 Use Both!

They complement each other:

```
┌─────────────────┐
│   Your Mac      │
├─────────────────┤
│                 │
│  VS Code Desktop├──────► Coder Workspaces
│                 │        (port 7080)
│                 │
│  Safari/Chrome  ├──────► code-server
│  on iPad        │        (port 8080)
└─────────────────┘
```

## 🚀 Example Workflows

### Workflow 1: Professional Development (Coder)
```bash
# Morning: Start your workspace
coder-start
open -a "Visual Studio Code"
# Click Coder icon → Open workspace
# Work all day with full VS Code Desktop features
```

### Workflow 2: iPad Coding (code-server)
```bash
# Start code-server
code-server start
# On iPad: Open http://your-mac-ip:8080
# Quick edits and reviews
```

### Workflow 3: Multiple Projects (Coder)
```bash
# Project 1: Node.js workspace
coder create frontend --template nodejs

# Project 2: Python workspace  
coder create backend --template python

# Project 3: Docker workspace
coder create services --template docker

# Switch between them in VS Code Desktop
```

## 🔧 Resource Usage

### code-server
- **Memory**: ~200-300MB
- **CPU**: Low
- **Storage**: Shares your ~/Projects
- **Start time**: ~5 seconds

### Coder
- **Memory**: ~500MB (server) + workspaces
- **CPU**: Low (server), varies (workspaces)
- **Storage**: Each workspace has its own volume
- **Start time**: ~30 seconds (first time)

## 📝 Management Commands

### code-server
```bash
code-server start     # Start container
code-server stop      # Stop container
code-server logs      # View logs
code-server status    # Check status
code-server update    # Update image
```

### Coder
```bash
coder-start      # Start Coder server
coder-stop       # Stop Coder server
coder-logs       # View server logs
coder-status     # Check status
coder-url        # Show access URLs

# CLI commands (after: brew install coder)
coder list       # List workspaces
coder create     # Create workspace
coder ssh        # SSH to workspace
coder code       # Open in VS Code
```

## 🎨 Customization

### code-server
Edit `~/Projects/.code-server/docker-compose.yml`:
- Change port
- Add volume mounts
- Adjust environment variables

### Coder
Edit `~/dotfiles-macos/config/coder/`:
- `docker-compose.yml` - Server config
- `templates/` - Workspace templates
- `.env` - Environment settings

## 🌐 Remote Access

Both support remote access via Tailscale or Cloudflare Tunnel!

### code-server
```bash
# Access from iPad on same Tailscale network
http://[mac-tailscale-ip]:8080
```

### Coder
```bash
# Access from any device on Tailscale network
http://[mac-tailscale-ip]:7080

# Use VS Code Desktop on any machine
coder login http://[mac-tailscale-ip]:7080
```

## 💰 Cost Comparison

Both are **FREE** and open source!

- **code-server**: MIT License
- **Coder**: AGPL License (free for personal use)

## 🎓 Learning Curve

### code-server: ⭐ Easy
- Install → Start → Open browser → Done
- Familiar VS Code interface

### Coder: ⭐⭐ Moderate
- Install → Configure → Create templates → Launch workspaces
- More features = more to learn
- Worth it for professional use

## 📦 Installation Status

✅ **code-server**: Already installed
   - Symlinked to `~/Projects/.code-server/`
   - Ready to use

✅ **Coder**: Just installed!
   - Located at `~/dotfiles-macos/config/coder/`
   - Run `./quickstart.sh` to begin

## 🎯 Quick Decision Guide

**Choose code-server if you need to:**
- Code from iPad right now
- Keep it simple
- Work on a single project

**Choose Coder if you want to:**
- Use VS Code Desktop
- Manage multiple environments
- Create reproducible dev setups
- Eventually collaborate with others

**Use both if you:**
- Code professionally (Coder)
- Also want iPad access (code-server)
- Like having options! 🎉

---

Need help? Check the READMEs:
- `config/code-server/README.md`
- `config/coder/README.md`
