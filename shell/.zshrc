# Add locations to $PATH variable
HOMEBREW_PATH="/opt/homebrew/bin:/usr/local/bin"
VSCODE_PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
TRASH_CLI_PATH="/opt/homebrew/opt/trash-cli/bin"
export PATH="$HOMEBREW_PATH:$TRASH_CLI_PATH:$VSCODE_PATH:${PNPM_HOME:+$PNPM_HOME:}$PATH"

# Initialize completion system early for plugins
autoload -Uz compinit && compinit

# Initialize antidote plugin manager
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
zstyle ':antidote:bundle' use-friendly-names 'yes'
antidote load

# Load environment variables from ~/.env
if [[ -d "$HOME/.env" ]]; then
  for file in "$HOME/.env/"*.zsh(N); do
    [[ -f $file ]] && source "$file"
  done
fi

# Syntax highlighting for man pages using bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# Initialize tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(fnm env --use-on-cd --shell zsh)"

# direnv - load/unload environment variables based on directory
command -v direnv &> /dev/null && eval "$(direnv hook zsh)"

# Profile switching
[[ -f ~/.config/profiles/profile.zsh ]] && source ~/.config/profiles/profile.zsh

# trash-cli aliases
if command -v trash-put &> /dev/null; then
  alias rm='trash-put'
  alias tp='trash-put'
  alias tl='trash-list'
  alias tr='trash-restore'
  alias te='trash-empty'
fi

# Load custom aliases and functions
source "$HOME/.shell/aliases.zsh"
source "$HOME/.shell/functions.zsh"