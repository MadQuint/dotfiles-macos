# Dotfiles macOS

A streamlined, privacy-first dotfiles configuration for macOS with multi-profile support, modern CLI tools, and automated workspace startup.

## Features

- **Privacy-focused**: Generic templates with env-based personalization
- **Multi-profile support**: Work, Labs, Personal with automatic git config switching
- **Coder workspaces**: Native (non-Docker) development environments with iPad access
- **Zsh shell** with Powerlevel10k theme and Antidote plugin manager
- **SSH key management** with macOS Keychain integration
- **Modern CLI tools**: ripgrep, fd, delta, lazygit, atuin, btop, tmux
- **Window management** with Yabai and skhd.zig
- **Automated workspace startup**: Safari + IntelliJ IDEA
- **Streaming setup** with Moonlight (client) and Sunshine (server)
- **Homebrew** package management via Brewfile
- **dotbot** for automated symlink management

## Quick Start

### Fresh macOS Installation

```bash
git clone https://github.com/MadQuint/dotfiles-macos.git ~/.dotfiles
cd ~/.dotfiles
./install
```

**The installer will:**

1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from Brewfile
3. Set up all dotfiles (symlinks)
4. Configure Oh My Zsh with Powerlevel10k
5. Prompt for personal details (name, email, work profiles)
6. Set up profile-specific git configurations

**You'll be asked:**

- Your full name
- Your email address
- Profile-specific emails (work, labs, personal)

This automatically creates personalized profiles and generates a local `.env` file (NOT committed to git).

### Existing Installation

```bash
cd ~/.dotfiles
./install
```

## What's Installed

### Development Tools

- **Git** + extras (delta, lazygit, gh, git-quick-stats)
- **Node.js** (via fnm - Fast Node Manager)
- **Coder** - Remote development workspaces (native, no Docker)
- **IntelliJ IDEA** - Java/Kotlin IDE
- **Visual Studio Code** - Code editor
- **Neovim** - Terminal-based editor
- **commitizen** - Conventional commits helper

### Shell & Terminal

- **Zsh** with Powerlevel10k theme
- **Antidote** - Plugin manager
- **tmux** - Terminal multiplexer
- **Alacritty** - GPU-accelerated terminal
- **eza** - Modern ls replacement
- **zoxide** - Smart cd with frecency
- **fzf** - Fuzzy finder
- **ripgrep** (rg) - Better grep
- **fd** - Better find
- **bat** - Better cat with syntax highlighting
- **atuin** - Magical shell history
- **direnv** - Auto-load environment variables

### System Tools

- **btop** - Beautiful system monitor
- **trash-cli** - Safe rm alternative
- **Yabai** - Tiling window manager
- **skhd.zig** - Hotkey daemon
- **Raycast** - Spotlight replacement
- **mackup** - Backup app settings

### Browsers

- **Safari** (default)
- **Brave Browser**
- **Google Chrome**
- **Microsoft Edge**

### Utilities

- **Homebrew** - Package manager
- **mas** - Mac App Store CLI
- **httpie** - User-friendly HTTP client
- **jq** - JSON processor
- **tldr** - Simplified man pages

### Streaming & Remote

- **Moonlight** - Game streaming client
- **Sunshine** - Streaming server
- **Microsoft Remote Desktop**
- **OrbStack** - Docker/container management

### Media & Design

- **Affinity Designer/Photo/Publisher**
- **Figma**
- **OBS Studio**
- **Screen Studio**
- **Plex**

### Communication

- **Microsoft Teams**
- **Discord**
- **WhatsApp**

### Security & Network

- **Little Snitch** - Network monitor
- **Micro Snitch** - Microphone/camera monitor
- **NextDNS** - DNS-based ad blocker
- **TripMode** - Network data limiter
- **WiFiMan** - Network analyzer

### Productivity

- **HiddenBar** - Menu bar organizer
- **Caffeine** - Prevent sleep
- **AppCleaner** - Uninstaller
- **DevCleaner** - Xcode cache cleaner
- **Latest** - App update checker
- **Shottr** - Screenshot tool
- **Dropover** - Drag & drop helper
- **Rocket** - Emoji picker

See `Brewfile` for the complete list.

## How to Start Everything

### Daily Startup (Automated)

Start your complete development environment:

```bash
# Start work environment (Safari + IntelliJ)
start-work

# Start labs environment
start-labs

# Or manually specify
start-workspace work
start-workspace labs
```

This will:

1. Switch to the appropriate profile (work/labs/personal)
2. Open Safari with your designated homepage
3. Launch IntelliJ IDEA
4. Set up environment variables for that profile

### Manual Startup

If you prefer to start things individually:

```bash
# Open Safari
open -a Safari

# Open IntelliJ IDEA
open -a "IntelliJ IDEA"

# Open VSCode
code

# Start tmux session
tmux new -s work

# Switch work profile
profile work
```

### LaunchAgents (Auto-start on Login)

VSCode can auto-start on macOS login:

```bash
# Enable VSCode auto-start
launch-vscode

# Disable VSCode auto-start
unlaunch-vscode

# Check status
launch-status
```

## Privacy & Security

✅ **What's NOT in the repository:**

- `.env` file (your personal configuration)
- SSH keys (`~/.ssh/`)
- Git credentials
- Any sensitive personal information

✅ **What IS in the repository:**

- Generic templates with placeholders
- Configuration scripts
- Documentation

The `.env` file is:

- Created locally during `./install`
- Added to `.gitignore`
- Contains your personal details
- Only stored on your machine

## Directory Structure

```
dotfiles-macos/
├── install                    # Main installation script
├── install.conf.yaml          # Dotbot configuration
├── Brewfile                   # Homebrew packages
├── README.md                  # This file
│
├── scripts/
│   ├── bootstrap.sh           # System bootstrap
│   ├── configure.sh           # Post-install setup
│   ├── install-brewfile.sh    # Install Homebrew packages
│   ├── setup-profiles.sh      # Configure work profiles
│   ├── profile-switch.sh      # Profile switcher utility
│   ├── start-workspace.sh     # Launch Safari + IntelliJ
│   └── manage-ssh.sh          # SSH key management
│
├── shell/
│   ├── .zshrc                 # Zsh configuration
│   ├── .zsh_plugins.txt       # Antidote plugins
│   ├── aliases.zsh            # Custom aliases
│   ├── functions.zsh          # Custom functions
│   └── starship.toml          # Starship prompt config
│
├── git/
│   ├── .gitconfig             # Main git config
│   └── profiles/
│       ├── work.config        # Work git settings
│       ├── labs.config        # Labs git settings
│       └── personal.config    # Personal git settings
│
├── config/
│   ├── alacritty.toml         # Terminal config
│   ├── tmux.conf              # Tmux config
│   ├── yabai/yabairc          # Window manager config
│   ├── skhd/skhdrc            # Hotkey daemon config
│   ├── mackup.cfg             # App settings backup
│   ├── coder/                 # Coder configuration
│   │   ├── manage.sh          # Server management
│   │   ├── setup.sh           # Quick setup
│   │   └── templates/         # Workspace templates
│   │       ├── intellij-workspace/
│   │       └── general-workspace/
│   └── launchagents/          # Auto-start services
│       └── com.user.vscode.plist
│
├── profiles/
│   ├── moonlight/config       # Streaming client
│   ├── sunshine/config        # Streaming server
│   └── .profile.current       # Current active profile
│
└── private/                   # Git-ignored directory
    └── ssh/                   # SSH key backups
```

## Usage

### Initial Setup (Post-Installation)

After running `./install`, the `configure.sh` script will:

1. Prompt you for personal details:

   ```
   Full name: [your response]
   Email address: [your response]
   Work email: [your response]
   ```

2. Create personalized profiles with your information

3. Generate local `.env` file with your configuration

4. Update git config automatically

### Work Profiles

Switch between work contexts with automatic git config updates:

```bash
# List available profiles
profile list

# Switch to work
profile w
# or
profile work

# Switch to labs
profile l
# or
profile labs

# Switch to personal
profile p
# or
profile personal

# Show current profile
profile current
```

### Personalizing Configuration

To customize your setup:

1. **Edit personal details:**

   ```bash
   vim ~/.env
   source ~/.config/profiles/work.sh
   ```

2. **Add to profiles:**
   Create new profile files in `~/.config/profiles/`

3. **Customize shell aliases:**
   Edit `shell/aliases.zsh`

### Zsh Plugins

Plugins are managed with Antidote. To update:

```bash
# Edit plugin list
vim ~/.zsh_plugins.txt

# Reload plugins
antidote update
```

Current plugins:

- zsh-autosuggestions
- zsh-completions
- zsh-syntax-highlighting
- mattmc3/zephyr (framework)
- git, brew, docker, fzf, history, macos (Oh My Zsh)

### CLI Tools

**direnv** - Auto-load environment variables by directory:

```bash
# In any project directory
echo 'export NODE_ENV=development' > .envrc
direnv allow
# Variables automatically loaded when entering directory
```

**trash-cli** - Safe alternative to rm:

```bash
trash-put file.txt     # Move to trash (alias: tp)
trash-list             # List trashed items (alias: tl)
trash-restore          # Restore from trash (alias: tr)
trash-empty            # Empty trash (alias: te)
```

**starship** - Alternative prompt (optional, currently using Powerlevel10k):

```bash
# To switch from Powerlevel10k to Starship:
# 1. Comment out p10k lines in .zshrc
# 2. Add: eval "$(starship init zsh)"
# 3. Config at ~/.config/starship.toml
```

### SSH Key Management

Securely manage SSH keys with macOS Keychain integration:

```bash
# Interactive mode (recommended for first-time)
./scripts/manage-ssh.sh

# Quick commands
./scripts/manage-ssh.sh generate work user@work.com  # Generate new key
./scripts/manage-ssh.sh backup work                   # Backup to private/
./scripts/manage-ssh.sh restore work                  # Restore from backup
./scripts/manage-ssh.sh list                          # List all keys
./scripts/manage-ssh.sh setup-config                  # Configure SSH for Keychain
```

**Features:**

- ✅ Automatic macOS Keychain integration (Touch ID unlock)
- ✅ Backup keys to `private/` directory (gitignored)
- ✅ Restore keys on new machines
- ✅ Profile-specific SSH keys (work, labs, personal)

### Coder Development Workspaces

Coder provides remote development workspaces running **natively** on your Mac (no Docker).

#### Quick Setup

```bash
# Run setup (first time only)
cd ~/.dotfiles/config/coder
./setup.sh
```

This starts the Coder server and imports workspace templates.

#### Create Workspaces

```bash
# IntelliJ workspace for Java
coder create my-java-project --template=intellij-workspace

# General workspace for Node.js/Python/Web
coder create my-web-app --template=general-workspace

# List workspaces
coder list

# Open in IntelliJ IDEA
coder open my-java-project --app intellij
```

#### Server Management

```bash
coder-start         # Start Coder server
coder-stop          # Stop server
coder-restart       # Restart server
coder-status        # Check status
coder-logs          # View logs
coder-url           # Show access URLs
```

#### iPad Access

Access Coder UI from your iPad:

1. Get your Mac's IP: `coder-url`
2. Open Safari on iPad
3. Navigate to `http://[your-mac-ip]:7080`
4. Create and manage workspaces from the browser

**See `config/coder/README.md` for complete documentation.**

### Moonlight & Sunshine

#### Sunshine (Streaming Server)

```bash
# Start service
sudo launchctl start homebrew.mxcl.sunshine

# Configure
vim ~/.config/sunshine/config
```

#### Moonlight (Streaming Client)

```bash
# Launch and pair with Sunshine server
# Configuration is at ~/.config/moonlight/config
```

## Cheatsheets

### Tmux Cheatsheet

**Session Management:**

```bash
tmux                    # Start new session
tmux new -s work        # Start new named session
tmux ls                 # List sessions
tmux attach -t work     # Attach to session
tmux kill-session -t work # Kill session
```

**Prefix Key:** `Ctrl-b` (press Ctrl+b, then the command)

**Window Management:**

```bash
Prefix c                # Create new window
Prefix ,                # Rename window
Prefix n                # Next window
Prefix p                # Previous window
Prefix 0-9              # Switch to window by number
Prefix w                # List windows
Prefix &                # Kill window
```

**Pane Management:**

```bash
Prefix %                # Split vertically
Prefix "                # Split horizontally
Prefix o                # Switch to next pane
Prefix ;                # Toggle last active pane
Prefix arrow keys       # Move between panes
Prefix z                # Toggle pane zoom
Prefix x                # Kill pane
Prefix {                # Move pane left
Prefix }                # Move pane right
Prefix Ctrl-o           # Rotate panes
Prefix !                # Break pane into window
```

**Resizing Panes:**

```bash
Prefix Ctrl-arrow       # Resize pane (hold Ctrl)
Prefix Alt-arrow        # Resize pane in steps of 5
```

**Copy Mode (scrollback):**

```bash
Prefix [                # Enter copy mode
Space                   # Start selection
Enter                   # Copy selection
Prefix ]                # Paste
q                       # Quit copy mode
```

**Miscellaneous:**

```bash
Prefix d                # Detach from session
Prefix t                # Show clock
Prefix ?                # List all keybindings
Prefix :                # Enter command mode
```

**Quick Commands in tmux:**

```bash
:new-window -n name     # Create named window
:split-window           # Split horizontally
:split-window -h        # Split vertically
:resize-pane -L 10      # Resize left 10 cells
```

### Git with Delta (better diffs)

```bash
git diff                # View changes with Delta pager
git log -p              # View commit history with diffs
git show <commit>       # Show commit with diff
git diff --name-only    # Just show changed file names
```

### Lazygit Cheatsheet

```bash
lazygit                 # Launch lazygit UI

# Within lazygit:
h/j/k/l or arrows       # Navigate
Space                   # Stage/unstage
a                       # Stage all
A                       # Unstage all
c                       # Commit
C                       # Commit using git-cz (commitizen)
P                       # Push
p                       # Pull
+                       # Create new branch
b                       # View branches
f                       # Fetch
m                       # Merge
r                       # Rebase
v                       # View files
?                       # Help
q                       # Quit
```

### FZF (Fuzzy Finder)

```bash
Ctrl-t                  # Paste selected files/dirs
Ctrl-r                  # Search command history
Alt-c                   # cd into selected directory

# In any list:
Ctrl-j/k                # Navigate
Ctrl-space              # Multi-select
Enter                   # Confirm
Esc                     # Cancel
```

### Eza (better ls)

```bash
ls                      # List with git status & icons
ll                      # Long format with all details
lt                      # Tree view
tree                    # Same as lt
llm                     # Sort by modified time
```

### Zoxide (smart cd)

```bash
z project               # Jump to directory containing "project"
z pro doc               # Jump to dir matching "pro" and "doc"
zi                      # Interactive selection
z -                     # Go back to previous directory
zoxide query project    # Query without changing directory
```

### Atuin (shell history)

```bash
Ctrl-r                  # Search history (enhanced)
atuin search query      # Search for specific command
atuin stats             # Show usage statistics
atuin sync              # Sync history (if registered)
```

### Ripgrep (rg - better grep)

```bash
rg "pattern"            # Search current directory
rg -i "pattern"         # Case-insensitive
rg -w "word"            # Match whole words
rg -t js "pattern"      # Search only JavaScript files
rg -g "*.txt" "pattern" # Search files matching glob
rg -l "pattern"         # List files with matches
rg -c "pattern"         # Count matches per file
```

### Btop (system monitor)

```bash
btop                    # Launch btop

# Within btop:
Esc                     # Main menu
m                       # Show/hide menu
p                       # Process selector
f                       # Filter processes
+/-                     # Increase/decrease update speed
q                       # Quit
```

### Yabai (window manager)

```bash
# Configured via skhd hotkeys (check ~/.config/skhd/skhdrc)
# Common shortcuts (if configured):
Alt-Return              # Open terminal
Alt-Shift-Space         # Toggle float
Alt-Space               # Rotate tree
Alt-f                   # Toggle fullscreen
Alt-h/j/k/l             # Focus window
```

### Direnv (auto-load env vars)

```bash
# In project directory:
echo 'export VAR=value' > .envrc
direnv allow            # Allow .envrc to load
direnv deny             # Deny .envrc
direnv reload           # Reload current .envrc
direnv status           # Show status
```

### Trash-CLI (safe delete)

```bash
trash-put file.txt      # Move to trash
trash-list              # List items in trash
trash-restore           # Restore interactively
trash-empty             # Empty trash
trash-empty 10          # Delete items older than 10 days
```

## First-Time Setup Checklist

After running `./install`:

- [ ] Configure Powerlevel10k: `p10k configure`
- [ ] Set default work profile: `profile w`
- [ ] Verify git config: `git config --list | grep user`
- [ ] Generate SSH keys: `./scripts/manage-ssh.sh` (interactive)
- [ ] Configure delta git diff: `git config --global core.pager delta`
- [ ] Setup atuin shell history: `atuin register` (optional)
- [ ] Start your workspace: `start-work`
- [ ] Configure IntelliJ IDEA with your preferences
- [ ] Set up Sunshine server IP in Moonlight (if using streaming)
- [ ] Close and reopen terminal

## Common Workflows

### Starting Your Day

```bash
# Start your work environment
start-work

# Or manually:
profile work              # Switch to work profile
tmux new -s work          # Start tmux session
open -a "IntelliJ IDEA"  # Open IDE
```

### Working with Git

```bash
# Quick status check
git status
git diff

# Use lazygit for complex operations
lazygit

# Commit with conventional commits
cz                       # Uses commitizen
```

### Project Navigation

```bash
z myproject              # Jump to project directory
ls                       # View files with eza
code .                   # Open in VSCode
```

### System Monitoring

```bash
btop                     # Beautiful system monitor
htop                     # Alternative system monitor
```

## Updating Dotfiles

```bash
cd ~/.dotfiles
git pull
./install
```

Your `.env` file will be preserved (not overwritten).

## Customization

### Adding New Packages

Edit `Brewfile` and run:

```bash
brew bundle
```

### Adding New Profiles

1. Copy profile template:

   ```bash
   cp git/profiles/work.config git/profiles/yourprofile.config
   ```

2. Edit with your details

3. Update `.env`:

   ```bash
   echo "YOURPROFILE_EMAIL=email@example.com" >> ~/.env
   ```

4. Create profile script in `~/.config/profiles/yourprofile.sh`

### Adding Shell Functions

Add to `shell/functions.zsh` and reload:

```bash
source ~/.zshrc
```

## Troubleshooting

### Zsh not loading plugins

```bash
# Regenerate antidote bundle
antidote bundle ~/.zsh_plugins.txt >! ~/.zsh_plugins.zsh

# Reload shell
exec zsh
```

### Git config not switching

Ensure work directories exist:

```bash
mkdir -p ~/Work ~/Personal
```

### Powerlevel10k instant prompt warnings

Run the configuration:

```bash
p10k configure
```

### Symlink conflicts

dotbot will ask to overwrite. Use force flag:

```bash
./install -f
```

## Security Notes

- ✅ Never commit `.env` file
- ✅ SSH keys should be in `~/.ssh/` (not in dotfiles)
- ✅ Use profile-specific SSH keys per context
- ✅ Regenerate SSH keys for new machines
- ✅ Keep GitHub SSH keys secure

## Resources

- [dotbot Documentation](https://github.com/anishathalye/dotbot)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Antidote](https://getantidote.github.io/)
- [Oh My Zsh](https://ohml.sh/)
- [Moonlight](https://moonlight-stream.org/)
- [Sunshine](https://github.com/LizardByte/Sunshine)

## License

MIT
