# Fresh macOS Installation Guide

Complete guide for setting up a new Mac with these dotfiles, including Coder.

## 🚀 Quick Install (One Command)

```bash
git clone https://github.com/yourusername/dotfiles-macos.git ~/.dotfiles && cd ~/.dotfiles && ./install
```

This will:
1. ✅ Install Xcode Command Line Tools
2. ✅ Install Homebrew
3. ✅ Install all packages (including Coder CLI)
4. ✅ Symlink dotfiles
5. ✅ Prompt for personal details (name, email)
6. ✅ Setup work profiles
7. ✅ Configure Coder (interactive)

## 📋 What Gets Asked During Installation

### User Configuration (Required)
```
Full name: John Doe
Email address: john@example.com
Work email: john@company.com
```

### Profile Configuration (Optional)
```
Labs email: [press enter to skip]
Personal email: [press enter to skip]
```

### Coder Configuration (Optional)
```
Configure Coder now? (Y/n): Y

Coder Security Configuration:
Auto-generate database password? (Y/n): Y
✓ Generated secure password

Access Configuration:
1) Local only (localhost:7080)
2) Tailscale network
3) Custom URL
Choose access method [1-3] (default: 1): 1

Start Coder now? (Y/n): Y
```

## 🔧 Manual Steps (If Needed)

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/dotfiles-macos.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run Installation

```bash
./install
```

This runs:
- `dotbot` for symlinks (via `install.conf.yaml`)
- `scripts/configure.sh` for personalization
- `scripts/setup-coder.sh` for Coder (if you say yes)

### 3. Post-Installation

```bash
# Reload shell
exec zsh

# Configure Powerlevel10k
p10k configure

# Switch to work profile
profile w

# Verify git config
git config --list | grep user
```

## 🐳 Coder-Specific Setup

### If You Skipped Coder During Install

```bash
~/dotfiles-macos/scripts/setup-coder.sh
```

### Manual Coder Setup

```bash
# 1. Configure .env
cd ~/dotfiles-macos/config/coder
cp .env.example .env
vim .env  # Set CODER_DB_PASSWORD

# 2. Start Coder
./quickstart.sh

# 3. Create admin account
open http://localhost:7080

# 4. Install CLI (already in Brewfile)
brew install coder

# 5. Login
coder login http://localhost:7080

# 6. Install VS Code extension
# Open VS Code → Extensions → Search "Coder"
```

## 🔐 Security & Privacy

### What's Stored Locally (Not in Git)

```
~/.dotfiles/.env                    # Your personal config
~/.dotfiles/config/coder/.env       # Coder passwords
~/.ssh/                             # SSH keys
```

All these are gitignored and remain private.

### What's in Git (Safe to Share)

```
Templates and examples
Scripts and automation
Generic configurations
Documentation
```

## 📦 What Gets Installed

### Via Homebrew (Brewfile)

**CLI Tools:**
- git, gh, lazygit, delta
- zsh, tmux, fzf, ripgrep, fd
- eza, bat, zoxide, direnv
- atuin, btop, neovim
- **coder** ← CLI for workspaces

**Applications:**
- OrbStack (Docker)
- Visual Studio Code
- Alacritty
- Raycast
- And more...

### Via Dotbot (Symlinks)

```
~/.zshrc          → shell/.zshrc
~/.gitconfig      → git/.gitconfig
~/.config/...     → config/...
```

## 🎯 Expected Flow

```
┌─────────────────────────────────────────┐
│  1. Clone dotfiles repo                 │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  2. Run ./install                       │
│     • Install Homebrew & packages       │
│     • Symlink configurations            │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  3. Interactive prompts                 │
│     • Your name                         │
│     • Your email                        │
│     • Work profiles                     │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  4. Coder setup? (Y/n)                  │
├─────────────────────────────────────────┤
│  Yes:                                   │
│  • Generate secure password             │
│  • Choose access method                 │
│  • Start Coder automatically            │
│                                         │
│  No:                                    │
│  • Skip for now                         │
│  • Run scripts/setup-coder.sh later    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│  5. Configuration complete!             │
│     • Reload shell: exec zsh            │
│     • Configure p10k                    │
│     • Access Coder: localhost:7080      │
└─────────────────────────────────────────┘
```

## ⚡ Quick Commands Reference

### Shell Aliases (After: source ~/.zshrc)

```bash
# Coder
coder-start       # Start Coder
coder-stop        # Stop Coder
coder-status      # Check status
coder-logs        # View logs

# Profiles
profile w         # Work profile
profile l         # Labs profile
profile p         # Personal profile

# Git
g                 # git alias
gwip              # git WIP commit
```

### Coder CLI (After: brew install coder)

```bash
coder login http://localhost:7080
coder list
coder create my-workspace
coder ssh my-workspace
coder code my-workspace  # Open in VS Code
```

## 🔄 Updating Dotfiles

```bash
cd ~/.dotfiles
git pull
./install  # Re-runs symlinks, preserves .env
```

Your personal `.env` files are never overwritten.

## 🆘 Troubleshooting

### Coder Won't Start

```bash
# Check Docker
docker info

# View logs
cd ~/.dotfiles/config/coder
./manage.sh logs

# Reset everything
./manage.sh clean
./quickstart.sh
```

### Missing Aliases

```bash
source ~/.zshrc
# or
exec zsh
```

### Git Config Issues

```bash
# Re-run configuration
cd ~/.dotfiles
./scripts/configure.sh
```

### Coder Configuration Issues

```bash
# Re-run Coder setup
~/dotfiles-macos/scripts/setup-coder.sh
```

## 📱 Remote Access (iPad/Other Devices)

### After Initial Setup

1. **Install Tailscale:**
   ```bash
   brew install --cask tailscale
   open -a Tailscale
   ```

2. **Get your IP:**
   ```bash
   tailscale ip -4
   ```

3. **Reconfigure Coder:**
   ```bash
   ~/dotfiles-macos/scripts/setup-coder.sh
   # Choose option 2: Tailscale network
   ```

4. **Access from iPad:**
   - Install Tailscale on iPad
   - Open: `http://[your-mac-ip]:7080`
   - Use VS Code extension on any device

## 🎓 First-Time Setup Checklist

After running `./install`:

- [ ] Reload shell: `exec zsh`
- [ ] Configure Powerlevel10k: `p10k configure`
- [ ] Switch to work profile: `profile w`
- [ ] Verify git: `git config --list | grep user`
- [ ] Access Coder: `open http://localhost:7080`
- [ ] Create Coder admin account
- [ ] Login via CLI: `coder login http://localhost:7080`
- [ ] Install VS Code Coder extension
- [ ] Create first workspace
- [ ] (Optional) Setup Tailscale for remote access

## 📚 Additional Documentation

- `config/coder/README.md` - Full Coder documentation
- `config/coder/SETUP_COMPLETE.md` - Coder quick reference
- `config/coder/VSCODE_SETUP.md` - VS Code extension guide
- `config/CODER_VS_CODESERVER.md` - Comparison guide

## 🎉 You're Done!

Your new Mac is now configured with:
- ✅ All development tools
- ✅ Personalized git config
- ✅ Work profile switching
- ✅ Coder for remote workspaces
- ✅ VS Code Desktop integration

Happy coding! 🚀
