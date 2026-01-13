# Tmux Developer Workflow Guide

## Quick Start

```bash
# Start tmux
tmux

# Or attach to existing session
tmux attach
```

## Key Features

### 📁 Session Management
- **Prefix + d** - Detach from session (keeps running)
- **Prefix + g** - Fuzzy search sessions (with tmux-fzf)
- **Prefix + w** - Fuzzy search windows
- Sessions auto-save every 15 minutes and restore on restart

### 🪟 Window Management
- **Prefix + c** - New window (in current directory)
- **Prefix + ,** - Rename window
- **Alt + H/L** - Switch windows (no prefix needed!)
- **Alt + j/k** - Move windows left/right
- **Prefix + &** - Close window

### 📱 Pane Management
- **Prefix + |** - Split vertically (in current directory)
- **Prefix + -** - Split horizontally (in current directory)
- **Prefix + h/j/k/l** - Resize panes
- **Prefix + m** - Maximize/restore pane
- **Prefix + x** - Close pane

### 🧭 Navigation (Vim-style)
- **Ctrl + h/j/k/l** - Move between panes (works with vim/nvim!)
- **Prefix + q** - Show pane numbers

### 📋 Copy Mode (Vim-style)
- **Prefix + [** - Enter copy mode
- **v** - Start selection
- **y** - Copy selection
- **Ctrl + v** - Rectangle selection
- **q** - Exit copy mode

### 🚀 Developer Shortcuts
- **Prefix + Ctrl + g** - Open lazygit in split pane
- **Prefix + Ctrl + h** - Open htop in split pane
- **o** - (in copy mode) Open highlighted file/URL

### 🔄 Misc
- **Prefix + r** - Reload config
- **Prefix + ?** - Show all key bindings
- **Prefix + t** - Show time

## Workflow Examples

### 1. Full-Stack Dev Setup
```bash
# Create session for project
tmux new -s myproject

# Window 1: Editor
nvim

# Window 2: Server (Prefix + c)
npm run dev

# Window 3: Tests (Prefix + c)
npm run test:watch

# Window 4: Git (Prefix + c, Prefix + Ctrl + g)
lazygit
```

### 2. Multiple Projects
```bash
# Project 1
tmux new -s frontend
cd ~/Projects/frontend && nvim

# Detach (Prefix + d)

# Project 2
tmux new -s backend
cd ~/Projects/backend && nvim

# Switch between projects with Prefix + g (fuzzy finder)
```

### 3. Quick Split Layout
```bash
# Start tmux
tmux

# Split for logs (Prefix + -)
# Split for git (Prefix + |)
# Resize to preference (Prefix + h/j/k/l)
```

## Plugin Management

### Install Plugins
```bash
# First time: prefix + I (capital i)
# This installs all plugins listed in tmux.conf
```

### Update Plugins
```bash
# Prefix + U
```

### Remove Plugins
```bash
# Remove from tmux.conf, then prefix + alt + u
```

## Tips & Tricks

1. **Mouse Support** - Click to select panes, drag to resize, scroll to see history
2. **Status Bar** - Shows session name, windows, time (at top)
3. **Auto-restore** - Sessions automatically restore after reboot
4. **Directory Awareness** - New panes/windows open in current directory
5. **Vim Integration** - Seamlessly navigate between vim and tmux panes
6. **Clipboard** - Copy with `y` works with system clipboard (via tmux-yank)

## Common Commands

```bash
# Sessions
tmux new -s name          # Create named session
tmux ls                   # List sessions
tmux attach -t name       # Attach to session
tmux kill-session -t name # Kill session

# Windows
Prefix + c                # New window
Prefix + ,                # Rename window
Prefix + w                # List windows
Prefix + n/p              # Next/previous window

# Panes
Prefix + |/-              # Split panes
Prefix + x                # Close pane
Prefix + space            # Cycle layouts
Prefix + z                # Zoom pane
```

## Troubleshooting

**Colors not working?**
```bash
echo $TERM  # Should be "tmux-256color" inside tmux
```

**Plugins not loading?**
```bash
# Install TPM manually
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# Then press Prefix + I
```

**Need to reset?**
```bash
rm -rf ~/.tmux/plugins
# Restart tmux and press Prefix + I
```
