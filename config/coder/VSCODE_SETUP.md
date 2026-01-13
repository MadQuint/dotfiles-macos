# VS Code Extension Setup

## Install Coder Extension

1. Open VS Code Desktop
2. Go to Extensions (⌘+Shift+X)
3. Search for: **Coder**
4. Install the extension by Coder
5. Reload VS Code

## Configure Extension

### Method 1: Via UI

1. Click the Coder icon in the sidebar
2. Click "Add Deployment"
3. Enter: `http://localhost:7080`
4. Click "Authenticate"
5. Complete authentication in browser

### Method 2: Via Settings

Add to your VS Code `settings.json`:

```json
{
  "coder.url": "http://localhost:7080",
  "coder.insecure": false
}
```

For Tailscale remote access:
```json
{
  "coder.url": "http://[your-tailscale-ip]:7080",
  "coder.insecure": false
}
```

## Using the Extension

### Connect to Workspace

1. Click Coder icon in sidebar
2. View your workspaces list
3. Click on a workspace
4. Click "Open in VS Code"
5. VS Code will open a new window connected to the workspace

### Quick Actions

- **Start workspace**: Right-click → Start
- **Stop workspace**: Right-click → Stop
- **View logs**: Right-click → View Logs
- **SSH to workspace**: Right-click → Open Terminal

## Keyboard Shortcuts (Optional)

Add to your `keybindings.json`:

```json
[
  {
    "key": "cmd+shift+c",
    "command": "coder.openWorkspace",
    "when": "!terminalFocus"
  },
  {
    "key": "cmd+shift+w",
    "command": "coder.listWorkspaces",
    "when": "!terminalFocus"
  }
]
```

## Extension Features

- ✅ Open workspaces directly in VS Code Desktop
- ✅ Start/stop workspaces from sidebar
- ✅ View workspace logs
- ✅ Access workspace terminal
- ✅ File sync between local and remote
- ✅ Use local extensions in remote workspace
- ✅ Git integration
- ✅ Debugging support

## Recommended Extensions to Install in Workspace

These extensions work well in Coder workspaces:

- GitLens
- ESLint
- Prettier
- Docker
- Remote - SSH (if you want CLI access)
- GitHub Copilot (if you have it)

## Troubleshooting

### Extension can't connect

```bash
# Check Coder is running
cd ~/dotfiles-macos/config/coder
./manage.sh status

# Check URL in VS Code matches deployment
# Should be: http://localhost:7080
```

### "Authentication failed"

1. Log in via browser: http://localhost:7080
2. In VS Code, click "Authenticate" again
3. Complete the OAuth flow

### Workspace won't start

```bash
# Check logs
./manage.sh logs

# Restart Coder
./manage.sh restart
```

## Tips

- **Local vs Remote**: Your local VS Code connects to remote workspace
- **Settings Sync**: Use VS Code Settings Sync to share config
- **Extensions**: Some extensions need to be installed in workspace
- **Terminal**: Opens directly in the workspace container
- **Files**: Access workspace files as if they were local
