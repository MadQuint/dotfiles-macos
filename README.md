# Dotfiles macOS

A comprehensive, privacy-first dotfiles configuration for macOS with support for multiple work profiles, Zsh with Powerlevel10k, and streaming support (Moonlight/Sunshine).

## Features

- **Privacy-focused**: Generic templates with env-based personalization
- **Multi-profile support**: Work, Labs, Personal with automatic git config switching
- **Zsh shell** with Powerlevel10k theme and Antidote plugin manager
- **SSH key management** with macOS Keychain integration
- **Modern CLI tools**: ripgrep, fd, delta, lazygit, atuin, btop
- **Coder workspaces**: Remote dev environments via VS Code Desktop
- **code-server**: Browser-based VS Code for iPad
- **Streaming setup** with Moonlight (client) and Sunshine (server)
- **Window management** with Yabai and skhd.zig
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

**The installer will:**
1. Install Xcode Command Line Tools
2. Install Homebrew and all packages from Brewfile (including Coder)
3. Install Oh My Zsh and Powerlevel10k
4. Set up all dotfiles (symlinks)
5. **Prompt for personal details** (name, email, work profiles)
6. **Optionally configure Coder** (auto-generate secure passwords)
7. **Start Coder** if you choose to

**You'll be asked:**
- Your full name
- Your email address
- Profile-specific emails (work, labs, personal)
- Whether to configure Coder development workspaces

This automatically creates personalized profiles and generates a local `.env` file (NOT committed to git).

📖 **See [FRESH_INSTALL.md](FRESH_INSTALL.md) for complete step-by-step guide.**

### Existing Installation

If you already have some configuration:

```bash
cd ~/.dotfiles
./install
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
.
├── install                          # Main installation script (uses dotbot)
├── install.conf.yaml               # dotbot configuration
├── .env.example                     # Template for personal configuration
├── Brewfile                         # Homebrew packages
├── README.md                        # This file
├── shell/
│   ├── .zshrc                      # Zsh configuration
│   ├── .zsh_plugins.txt            # Antidote plugins manifest
│   ├── aliases.zsh                 # Custom aliases
│   ├── functions.zsh               # Custom functions
│   └── p10k.zsh                    # Powerlevel10k config
├── git/
│   ├── .gitconfig                  # Main git config (generic)
│   └── profiles/
│       ├── work.config             # Work profile
│       ├── labs.config             # Labs profile
│       └── personal.config         # Personal profile
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
    ├── configure.sh                # Post-install personalization
    └── profile-switch.sh           # Profile switcher
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
# rm command is aliased to remind you to use trash
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

See `private/README.md` for detailed security practices.

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

## First-Time Setup Checklist

After running `./install`:

- [ ] Configure Powerlevel10k: `p10k configure`
- [ ] Set default work profile: `profile w`
- [ ] Verify git config: `git config --list | grep user`
- [ ] Generate SSH keys: `./scripts/manage-ssh.sh` (interactive)
- [ ] Configure delta git diff: `git config --global core.pager delta`
- [ ] Setup atuin shell history: `atuin register` (optional)
- [ ] Set up Sunshine server IP in Moonlight
- [ ] Close and reopen terminal

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
