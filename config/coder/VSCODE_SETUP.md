# VS Code Extension Setup

## 🎯 Goal: Full VS Code Desktop with Microsoft Extensions

Unlike code-server, Coder lets you use **actual VS Code Desktop** with:
- ✅ Microsoft extensions (Copilot, IntelliCode, etc.)
- ✅ Settings Sync with your Microsoft/GitHub account
- ✅ Your complete VS Code profile
- ✅ All extensions work (no restrictions)

## 📦 Two Ways to Connect

### Method 1: Coder Extension (Recommended)
Direct integration with one-click workspace opening.

### Method 2: Remote-SSH (Manual)
Traditional SSH connection for more control.

---

## 🚀 Method 1: Coder Extension (Easy)

### Step 1: Install Coder Extension

1. Open VS Code Desktop
2. Go to Extensions (⌘+Shift+X)
3. Search for: **Coder**
4. Install the extension by Coder
5. Reload VS Code

### Step 2: Connect to Coder

1. Click the Coder icon in the sidebar
2. Click "Add Deployment"
3. Enter: `http://localhost:7080` (or your Tailscale URL)
4. Click "Authenticate"
5. Complete authentication in browser

### Step 3: Open a Workspace

1. Click Coder icon in sidebar
2. View your workspaces list
3. Click on a workspace
4. Click "Open in VS Code" button
5. VS Code Desktop opens a new window connected to the workspace

### Step 4: Sign In & Sync

Once connected to the workspace:
1. Click account icon (bottom left)
2. Sign in with Microsoft/GitHub
3. Enable Settings Sync
4. Your profile, extensions, and settings sync automatically!

---

## 🔧 Method 2: Remote-SSH (Advanced)

### Step 1: Install Remote-SSH Extension

```
Extension: ms-vscode-remote.remote-ssh
```

### Step 2: Configure SSH

```bash
# On your Mac, configure Coder SSH
coder config-ssh
```

This adds Coder workspaces to your `~/.ssh/config`

### Step 3: Connect via SSH

1. Open VS Code
2. Press ⌘+Shift+P
3. Type: "Remote-SSH: Connect to Host"
4. Select your Coder workspace (e.g., `coder.my-workspace`)
5. VS Code opens connected to workspace

### Step 4: Sign In

Same as Method 1 - sign in and enable Settings Sync.

---

## ✨ What You Get

### Microsoft Extensions Work!

All these extensions work in Coder workspaces:

- ✅ **GitHub Copilot** - AI pair programmer
- ✅ **GitHub Copilot Chat** - AI assistant
- ✅ **IntelliCode** - AI-assisted development
- ✅ **Remote Development** - SSH, Containers
- ✅ **C#** - Full .NET support
- ✅ **Python** - Microsoft Python extension
- ✅ **Jupyter** - Notebooks support
- ✅ **Azure extensions** - Full Azure support
- ✅ **Live Share** - Real-time collaboration

### Settings Sync

Your entire VS Code profile syncs:
- Extensions
- Settings (settings.json)
- Keybindings
- Snippets
- UI state
- Themes

### Full Development Environment

- Remote terminal access
- Port forwarding (preview web apps)
- File system access
- Git integration
- Debugging support
- IntelliSense and autocomplete

---

## 🎨 Recommended Extensions for Remote Dev

Install these on your Mac (they'll work in all workspaces):

### Must-Have
```
GitHub.copilot                    # AI pair programming
GitHub.copilot-chat               # AI chat assistant
eamodio.gitlens                   # Git superpowers
ms-vscode-remote.remote-ssh       # SSH support
ms-azuretools.vscode-docker       # Docker integration
```

### Language Support
```
ms-python.python                  # Python
ms-vscode.cpptools               # C/C++
golang.go                         # Go
rust-lang.rust-analyzer          # Rust
ms-dotnettools.csharp            # C#/.NET
```

### Productivity
```
esbenp.prettier-vscode           # Code formatter
dbaeumer.vscode-eslint           # JavaScript linting
streetsidesoftware.code-spell-checker  # Spell check
usernamehw.errorlens             # Inline errors
```

---

## 🔐 Sign In Options

### Option 1: Microsoft Account
- Access to all Microsoft extensions
- Settings Sync with OneDrive
- Azure integration

### Option 2: GitHub Account
- GitHub Copilot access
- Settings Sync with GitHub
- GitHub integration

**You can sign in with both!**

---

## 🎯 Using VS Code with Coder

### Open Workspace (Coder Extension)
```bash
# Via Coder icon in sidebar:
Click workspace → "Open in VS Code"
```

### Open Workspace (CLI)
```bash
# From terminal on your Mac:
coder code my-workspace

# Or via SSH:
coder ssh my-workspace
# Then in VS Code: Remote-SSH → Connect
```

### One-Click from Web UI
1. Go to http://localhost:7080
2. Click on a workspace
3. Click "VS Code Desktop" button
4. VS Code opens automatically!

---

## 🛠️ Workspace Features

### Port Forwarding
```bash
# In workspace terminal:
npm run dev  # Starts on port 3000

# VS Code auto-detects and forwards port
# Open in browser: http://localhost:3000
```

### Terminal Access
- Full terminal in VS Code
- Multiple terminals
- Split terminals
- Shell integration

### File Sync
- Real-time file sync
- Git integration
- Source control panel
- Search across workspace

### Debugging
- Full debugging support
- Breakpoints
- Watch variables
- Debug console
- Launch configurations

---

## 📱 Remote Access (iPad/Other Devices)

### From iPad with Tailscale

1. Install VS Code on iPad
2. Install Coder extension
3. Connect to: `http://[tailscale-ip]:7080`
4. Open workspaces directly in iPad VS Code!

**Or use code-server for browser access:**
- VS Code Desktop on Mac: Use Coder
- Browser on iPad: Use code-server (http://localhost:8080)

---

## 🆚 Comparison: VS Code in Coder vs code-server

| Feature | Coder (VS Code Desktop) | code-server (Browser) |
|---------|-------------------------|----------------------|
| Microsoft Extensions | ✅ Yes | ❌ No |
| GitHub Copilot | ✅ Yes | ❌ No |
| Settings Sync | ✅ Yes | ⚠️ Limited |
| Full Extension API | ✅ Yes | ⚠️ Limited |
| Native Performance | ✅ Yes | ⚠️ Browser-limited |
| Offline Work | ✅ Yes | ❌ No |
| Debugging | ✅ Full | ⚠️ Limited |
| Terminal | ✅ Native | ⚠️ Browser |
| iPad Access | ⚠️ Needs app | ✅ Browser |

**Best of both worlds:**
- **Mac**: Use Coder + VS Code Desktop
- **iPad**: Use code-server in browser

---

## 🐛 Troubleshooting

### Extension Won't Install

**Issue:** Microsoft extension blocked

**Solution:** You're in Coder workspace - Microsoft extensions work!
```bash
# Install normally via Extensions panel
# Or via CLI:
code --install-extension GitHub.copilot
```

### Settings Not Syncing

**Solution:**
1. Sign in to Microsoft/GitHub account
2. Enable Settings Sync (⌘+Shift+P → "Settings Sync: Turn On")
3. Wait for sync to complete

### Can't Connect to Workspace

**Solution:**
```bash
# Check Coder is running
coder-status

# Check workspace is running
coder list

# Restart workspace
coder stop my-workspace
coder start my-workspace

# Reconnect
coder code my-workspace
```

### "Remote Host Key Changed"

**Solution:**
```bash
# Remove old SSH key
ssh-keygen -R "coder.my-workspace"

# Reconnect
coder code my-workspace
```

### Slow Extension Installation

**Cause:** Extensions install in remote workspace

**Solution:** Be patient or pre-install common extensions in template.

---

## 💡 Pro Tips

### 1. Install Extensions in Workspace Template

Edit `main.tf` to pre-install extensions:
```hcl
startup_script = <<-EOT
  #!/bin/bash
  code --install-extension GitHub.copilot
  code --install-extension eamodio.gitlens
  code --install-extension ms-python.python
EOT
```

### 2. Use Settings Sync

Enable Settings Sync to share config across all workspaces.

### 3. Use Workspace-Specific Settings

Create `.vscode/settings.json` in workspace for project-specific config.

### 4. Port Forwarding

VS Code auto-forwards common dev ports (3000, 8080, etc.).

### 5. Remote Development Pack

Install Microsoft's Remote Development extension pack:
```
ms-vscode-remote.vscode-remote-extensionpack
```

---

## 🎓 First-Time Setup Checklist

- [ ] Install Coder extension in VS Code
- [ ] Connect to Coder deployment
- [ ] Sign in with Microsoft/GitHub
- [ ] Enable Settings Sync
- [ ] Install GitHub Copilot
- [ ] Create test workspace
- [ ] Open workspace in VS Code Desktop
- [ ] Verify extensions work
- [ ] Test Copilot suggestions
- [ ] Configure terminal preferences

---

## 📚 Resources

- **VS Code Remote Dev**: https://code.visualstudio.com/docs/remote/remote-overview
- **Coder Extension**: https://marketplace.visualstudio.com/items?itemName=coder.coder-remote
- **GitHub Copilot**: https://github.com/features/copilot
- **Settings Sync**: https://code.visualstudio.com/docs/editor/settings-sync

---

## 🎉 Result

You get **full VS Code Desktop** experience with:
- ✅ All Microsoft extensions
- ✅ GitHub Copilot AI
- ✅ Your complete profile
- ✅ Settings sync
- ✅ Remote development
- ✅ Native performance

**No compromises!** This is real VS Code, just running against a remote workspace.

