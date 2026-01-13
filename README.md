# Dotfiles macOS

A comprehensive dotfiles configuration for macOS with support for multiple work profiles, Zsh with Powerlevel10k, and streaming support (Moonlight/Sunshine).

## Features

- **Multi-profile support**: work, Yourzoned, Personal with automatic git config switching
- **Zsh shell** with Powerlevel10k theme and Antidote plugin manager
- **VS Code** configuration with recommended extensions
- **Streaming setup** with Moonlight (client) and Sunshine (server)
- **Homebrew** package management via Brewfile
- **Automated bootstrap** script for fresh macOS setup
- **dotbot** for symlink management

## Quick Start

### Fresh macOS Installation

```bash
git clone https://github.com/MadQuint/dotfiles-macos.git ~/.dotfiles
cd ~/.dotfiles
./install
```

This will:
1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from Brewfile
3. Install Oh My Zsh and Powerlevel10k
4. Set up all dotfiles (symlinks)
5. Configure work profiles

### Existing Installation

If you already have some configuration, just run:

```bash
cd ~/.dotfiles
./install
```

## Directory Structure

```
.
├── install                          # Main installation script (uses dotbot)
├── install.conf.yaml               # dotbot configuration
├── Brewfile                         # Homebrew packages
├── README.md                        # This file
├── shell/
│   ├── .zshrc                      # Zsh configuration
│   ├── .zsh_plugins.txt            # Antidote plugins manifest
│   ├── aliases.zsh                 # Custom aliases
│   ├── functions.zsh               # Custom functions
│   └── p10k.zsh                    # Powerlevel10k config
├── git/
│   ├── .gitconfig                  # Main git config
│   └── profiles/
│       ├── work.config      # work profile
│       ├── yourzoned.config        # Yourzoned profile
│       └── personal.config         # Personal profile
├── vscode/
│   ├── settings.json               # VS Code settings
│   └── keybindings.json            # VS Code keybindings
├── profiles/
│   ├── moonlight/
│   │   └── config                  # Moonlight client config
│   ├── sunshine/
│   │   └── config                  # Sunshine server config
│   └── .profile.current            # Current active profile
└── scripts/
    ├── bootstrap.sh                # System bootstrap
    ├── install-brewfile.sh         # Install packages
    ├── setup-profiles.sh           # Configure profiles
    └── profile-switch.sh           # Profile switcher
```

## Usage

### Work Profiles

Switch between work contexts with automatic git config updates:

```bash
# List available profiles
profile list

# Switch to work
profile jb
# or
profile work

# Switch to Yourzoned
profile yz
# or
profile yourzoned

# Switch to Personal
profile p
# or
profile personal

# Show current profile
profile current
```

This automatically:
- Updates git user email
- Sets up SSH keys for the profile
- Sources profile-specific aliases
- Updates environment variables

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
- git (Oh My Zsh)
- brew (Oh My Zsh)
- docker (Oh My Zsh)
- fzf (Oh My Zsh)
- history (Oh My Zsh)
- macos (Oh My Zsh)

### VS Code

Settings are automatically symlinked. To customize:

1. Edit `vscode/settings.json`
2. Run `./install` to update symlinks

Installed extensions will be suggested on first open.

### Moonlight & Sunshine

#### Sunshine (Streaming Server)

Install and run the Sunshine server for game streaming:

```bash
# Install via Homebrew
brew install sunshine

# Start service
sudo launchctl start homebrew.mxcl.sunshine

# Configure
# Edit ~/.config/sunshine/config
```

#### Moonlight (Streaming Client)

```bash
# Install via Homebrew
brew install moonlight-qt

# Launch and pair with Sunshine server
# Configuration is at ~/.config/moonlight/config
```

### Git Configuration

Each profile has its own git configuration:

1. **work** (`~/Work/work/*`)
   - Email: gianni@work.com
   - SSH: ~/.ssh/work

2. **Yourzoned** (`~/Work/yourzoned/*`)
   - Email: gianni@yourzoned.com
   - SSH: ~/.ssh/yourzoned

3. **Personal** (`~/Personal/*`)
   - Email: gianni@personal.com
   - SSH: ~/.ssh/personal

Switching profiles automatically updates git config.

## Updating Dotfiles

```bash
cd ~/.dotfiles
git pull
./install
```

## Customization

### Adding New Packages

Edit `Brewfile` and add packages, then run:

```bash
brew bundle
```

### Adding New Profiles

1. Create a new git config in `git/profiles/newprofile.config`
2. Add conditional include in `git/.gitconfig`
3. Add entry to `scripts/setup-profiles.sh`
4. Run `./install`

### Adding Shell Aliases

Add to `shell/aliases.zsh` and reload:

```bash
source ~/.zshrc
```

## First-Time Setup Checklist

After running `./install`:

- [ ] Configure Powerlevel10k: `p10k configure`
- [ ] Set default work profile: `profile jb` (or other)
- [ ] Update git emails in `.config/git/profiles/*.config`
- [ ] Add SSH keys to `~/.ssh/` for each profile
- [ ] Configure VS Code extensions (automatic suggestion)
- [ ] Set up Sunshine server IP in Moonlight
- [ ] Configure macOS system preferences as needed

## Requirements

- macOS 10.14+
- Git
- Internet connection

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
mkdir -p ~/Work/work ~/Work/yourzoned ~/Personal
```

### Powerlevel10k instant prompt warnings

Run the configuration:

```bash
p10k configure
```

### Symlink conflicts

dotbot will ask to overwrite. Use `-r` flag to force relink:

```bash
./install -r
```

## Resources

- [dotbot Documentation](https://github.com/anishathalye/dotbot)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Antidote](https://getantidote.github.io/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Moonlight](https://moonlight-stream.org/)
- [Sunshine](https://github.com/LizardByte/Sunshine)

## License

MIT
