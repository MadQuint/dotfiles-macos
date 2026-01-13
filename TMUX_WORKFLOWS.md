# Tmux Developer Workflows

## 🌐 Web Development Workflow

### Setup: Frontend Project (React/Next.js/Vue)

```bash
# 1. Start named session
tmux new -s frontend

# You're now in Window 1 (editor)
cd ~/Projects/my-app
nvim
# or: code .

# 2. Create Window 2 for dev server (Prefix + c)
npm run dev
# or: yarn dev

# 3. Create Window 3 for tests (Prefix + c)
npm run test:watch

# 4. Create Window 4 split for git + terminal (Prefix + c)
# Split it vertically (Prefix + |)
# Left side: lazygit (Prefix + Ctrl + g)
# Right side: terminal for quick commands

# 5. Rename windows for clarity
# Go to Window 1: Prefix + , then type "editor"
# Go to Window 2: Prefix + , then type "server"
# Go to Window 3: Prefix + , then type "tests"
# Go to Window 4: Prefix + , then type "git"
```

**Result:**
```
┌─────────────────────────────────────────┐
│ [editor] [server] [tests] [git]        │ ← Windows (tabs)
├─────────────────────────────────────────┤
│                                         │
│         Your Editor (nvim/vscode)       │
│                                         │
└─────────────────────────────────────────┘
```

Switch between windows: **Alt + H/L** (no prefix!)

---

## 🔧 Full-Stack Development Workflow

### Setup: Frontend + Backend + Database

```bash
# Session for entire project
tmux new -s fullstack

# Window 1: Frontend
cd ~/Projects/my-app/frontend
nvim

# Window 2: Frontend Server (Prefix + c)
cd ~/Projects/my-app/frontend
npm run dev

# Window 3: Backend (Prefix + c)
# Split horizontally (Prefix + -)
# Top: Editor
cd ~/Projects/my-app/backend
nvim
# Bottom: Server
npm run dev

# Window 4: Database (Prefix + c)
# Top: MongoDB/PostgreSQL logs
mongod
# or: docker-compose up postgres
# Bottom: Database client
mongosh
# or: psql

# Window 5: Git + Tools (Prefix + c)
# Split into 4 quadrants
# Top-left: lazygit (Prefix + Ctrl + g)
# Top-right: System monitor (Prefix + Ctrl + h)
# Bottom: Terminal for commands
```

---

## 🐍 Data Science / Python Workflow

```bash
# Session for data project
tmux new -s datascience

# Window 1: Jupyter
jupyter lab
# Access at http://localhost:8888

# Window 2: Editor (Prefix + c)
nvim analysis.py

# Window 3: Python REPL (Prefix + c)
# Split for interactive testing
# Top: ipython or python
ipython
# Bottom: Run scripts
python script.py

# Window 4: Data exploration (Prefix + c)
# Terminal for quick pandas/sql queries
```

---

## 🚀 Daily Workflow Example

### Morning: Starting Work

```bash
# 1. Check existing sessions
tmux ls

# 2. Attach to yesterday's work (auto-restored!)
tmux attach -t frontend

# 3. Everything is exactly as you left it:
#    - Editor with open files
#    - Server still running
#    - Git status visible
#    - Tests in watch mode
```

### During Day: Multiple Projects

```bash
# Switch to different project
Prefix + d  # Detach from current

tmux new -s backend  # Start new project
# Or attach: tmux attach -t backend

# Quick switching
Prefix + g  # Fuzzy finder - type project name
```

### Evening: End of Day

```bash
# Option 1: Just close terminal
# Sessions auto-save and restore tomorrow!

# Option 2: Explicitly detach
Prefix + d

# Option 3: Kill session when done
tmux kill-session -t frontend
```

---

## 💡 Pro Tips & Patterns

### 1. Standard Layout Template
```bash
# Use this script to quickly set up projects
tmux new -s project -d
tmux rename-window -t project:1 'editor'
tmux send-keys -t project:1 'cd ~/Projects/myapp && nvim' C-m

tmux new-window -t project:2 -n 'server'
tmux send-keys -t project:2 'cd ~/Projects/myapp && npm run dev' C-m

tmux new-window -t project:3 -n 'tests'
tmux send-keys -t project:3 'cd ~/Projects/myapp && npm test' C-m

tmux new-window -t project:4 -n 'git'
tmux send-keys -t project:4 'cd ~/Projects/myapp && lazygit' C-m

tmux attach -t project
```

### 2. Quick Commands Setup

Create aliases in your `.zshrc`:
```bash
# Quick project starter
alias tm-start='tmux new -s $(basename $PWD)'

# Attach or create
alias tm='tmux attach || tmux new'

# Kill all sessions
alias tm-kill='tmux kill-server'
```

### 3. Pane Layout Patterns

**Side-by-side (50/50):**
```
┌──────────┬──────────┐
│          │          │
│  Editor  │  Server  │
│          │          │
└──────────┴──────────┘
```
Commands: `Prefix + |`

**Main + Helper (70/30):**
```
┌─────────────┬─────┐
│             │     │
│   Editor    │ Git │
│             │     │
└─────────────┴─────┘
```
Commands: `Prefix + |` then `Prefix + l` (resize right)

**Editor + 2 Terminals:**
```
┌──────────────────┐
│                  │
│     Editor       │
│                  │
├─────────┬────────┤
│ Server  │ Tests  │
└─────────┴────────┘
```
Commands: `Prefix + -` then `Prefix + |` on bottom

**Quad Layout:**
```
┌─────────┬─────────┐
│ Editor  │ Server  │
├─────────┼─────────┤
│ Tests   │  Git    │
└─────────┴─────────┘
```
Commands: `Prefix + |`, `Prefix + -` on both sides

### 4. Zoom & Focus

When you need to focus on one pane:
- **Prefix + m** → Maximize current pane
- Do your work
- **Prefix + m** → Restore layout

### 5. Copy/Paste from Logs

Viewing server logs and need to copy error:
1. **Prefix + [** → Enter copy mode
2. Navigate with **h/j/k/l**
3. **v** → Start selection
4. **y** → Copy
5. Paste anywhere with **Cmd + V**

### 6. Session Organization

```bash
Work projects:
- tmux new -s work-frontend
- tmux new -s work-backend
- tmux new -s work-devops

Personal projects:
- tmux new -s labs-experiment
- tmux new -s personal-blog

Quick tasks:
- tmux new -s scratch  # Temporary session
```

---

## 🎯 Common Scenarios

### Scenario 1: "Server is stuck, need to restart"
```bash
# Switch to server window: Alt + L (or H)
# Kill process: Ctrl + C
# Restart: Up arrow + Enter
# Switch back to editor: Alt + H
```

### Scenario 2: "Need to quickly check git status"
```bash
# From any window:
Prefix + Ctrl + g  # Opens lazygit in split
# Check status, stage changes
# Close: q
```

### Scenario 3: "Running long command, want to do something else"
```bash
# Let it run in background
Prefix + d  # Detach
# Do other work in terminal
# Check back later:
tmux attach
```

### Scenario 4: "Need to debug in multiple files"
```bash
# In editor window, split your editor vertically
# Or create new tmux pane: Prefix + |
# Open second file
# Use Ctrl + h/l to jump between files
```

---

## 🔑 Essential Shortcuts (Cheat Sheet)

**Always remember: Prefix = Ctrl-a**

| Shortcut | Action |
|----------|--------|
| `Prefix + ?` | **Show all shortcuts** |
| `Prefix + d` | Detach session |
| `Prefix + c` | New window |
| `Prefix + ,` | Rename window |
| `Alt + H/L` | Previous/Next window |
| `Prefix + \|` | Split vertical |
| `Prefix + -` | Split horizontal |
| `Ctrl + h/j/k/l` | Move between panes |
| `Prefix + m` | Maximize/restore pane |
| `Prefix + x` | Close pane |
| `Prefix + [` | Copy mode |
| `Prefix + r` | Reload config |

---

## 🆘 Troubleshooting

**"I'm stuck in a command, can't get out!"**
- Try: `Ctrl + C` (kill command)
- Or: `Ctrl + D` (exit shell)
- Or: `Prefix + x` (close pane)

**"My session disappeared!"**
- Check: `tmux ls`
- Restore: `tmux attach -t name`
- Sessions auto-restore after reboot!

**"Plugins not working?"**
- Install: `Prefix + I` (capital i)
- Update: `Prefix + U`
- Reload config: `Prefix + r`

**"Colors look wrong"**
- Check inside tmux: `echo $TERM` → should be `tmux-256color`
- Restart tmux if needed

---

## 📚 Next Steps

1. **Practice basic splits** (5 min)
   - Start tmux, split a few times, move around
   
2. **Set up one real project** (15 min)
   - Create session, add windows, customize layout
   
3. **Use for one day** (1 day)
   - Detach, reattach, see auto-restore working
   
4. **Add your own shortcuts** (optional)
   - Edit `~/.tmux.conf`
   - Add custom bindings for your tools

**You'll never want to work without tmux again!** 🚀
