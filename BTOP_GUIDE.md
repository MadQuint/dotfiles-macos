# btop - Beautiful System Monitor

## 🚀 Quick Start

```bash
# Launch btop
btop

# Exit
q or Ctrl-c
```

## 📊 What You See

btop shows 4 main sections (top to bottom):

1. **CPU Usage** - Per-core utilization with graphs
2. **Memory (RAM)** - Used/available memory
3. **Network** - Upload/download speed
4. **Processes** - Running applications (like Activity Monitor)

## ⌨️ Essential Shortcuts

### Navigation
- **↑/↓ or j/k** - Move through process list
- **g/G** - Jump to top/bottom
- **PgUp/PgDn** - Page up/down

### Process Management
- **k** - Kill selected process (sends SIGTERM)
- **t** - Tree view (show process hierarchy)
- **r** - Reverse sort order
- **c** - Sort by CPU usage
- **m** - Sort by memory usage

### Filtering & Search
- **f** - Filter processes (type to search)
- **Esc** - Clear filter
- **e** - Toggle command line view (full vs short)

### Views & Settings
- **1-4** - Toggle sections on/off
  - **1** - CPU graph
  - **2** - Memory
  - **3** - Network
  - **4** - Processes
- **h** - Help menu (shows all shortcuts)
- **o** - Options menu
- **+/-** - Change update speed

### Themes
- **T** - Toggle theme (cycles through built-in themes)

## 💡 Common Use Cases

### 1. Find CPU-Hogging Process
```bash
btop
# Press 'c' to sort by CPU
# Look at top of process list
# Press 'k' to kill if needed
```

### 2. Check Memory Usage
```bash
btop
# Press 'm' to sort by memory
# See which apps are using most RAM
```

### 3. Monitor Network Activity
```bash
btop
# Watch the Network section
# See real-time upload/download speeds
```

### 4. Tree View (See App Dependencies)
```bash
btop
# Press 't' for tree view
# See parent-child process relationships
```

### 5. Quick System Overview
```bash
# Run in tmux split for monitoring
btop

# In tmux:
# Prefix + | (split)
# Left: your work
# Right: btop monitoring
```

## 🎨 Customization

### Change Theme
```bash
# Press 'T' multiple times to cycle themes
# Or press 'o' for options → select theme
```

Popular themes:
- **gruvbox_dark** (matches your Starship!)
- **tokyo-night**
- **nord**
- **monokai**

### Config Location
```bash
~/.config/btop/btop.conf
```

## 🆚 btop vs Other Tools

| Tool | Purpose |
|------|---------|
| **btop** | Beautiful, full-featured (our choice) |
| **htop** | Classic, lighter weight |
| **top** | Built-in macOS (basic) |
| **Activity Monitor** | macOS GUI |

btop advantages:
- ✅ GPU monitoring (if available)
- ✅ Network graphs
- ✅ Beautiful UI with themes
- ✅ Mouse support
- ✅ More intuitive than htop

## 🎯 Pro Tips

1. **Add to tmux**: Bind to quick launch
   ```bash
   # Already in your tmux.conf!
   # Prefix + Ctrl + h opens btop in split
   ```

2. **Create alias for quick launch**:
   ```bash
   # Add to .zshrc
   alias top='btop'
   ```

3. **Monitor during development**:
   ```bash
   # Keep btop running in tmux pane
   # Watch for memory leaks in your app
   ```

4. **Troubleshoot slow Mac**:
   ```bash
   btop
   # Sort by CPU (c) or Memory (m)
   # Find the culprit
   # Kill if needed (k)
   ```

## 🔧 Integration with Your Setup

### In Tmux
```bash
# Quick launch from anywhere
Prefix + Ctrl + h

# Or manually
Prefix + | (split)
btop
```

### As Dashboard
```bash
# Create monitoring session
tmux new -s monitor
btop

# Split for other monitoring tools
Prefix + -
lazygit  # or other tools
```

### SSH into Servers
```bash
ssh user@server
btop
# Monitor remote system beautifully!
```

## 🆘 Common Issues

**"Terminal too small" error**
- Resize terminal window larger
- Or press '4' to hide processes section

**Colors look weird**
- Press 'T' to change theme
- Try gruvbox_dark or default

**Process killed wrong app**
- Use 'f' to filter/search first
- Check process name carefully before 'k'

**Too much info**
- Press 1/2/3/4 to toggle sections
- Hide what you don't need

## 📚 More Info

```bash
# Help inside btop
h

# Man page
man btop

# Config options
btop --help
```

---

**btop makes system monitoring actually enjoyable!** 🎨📊
