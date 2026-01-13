# ZSH aliases
alias ohmyzsh="code ~/.oh-my-zsh"
alias zsh_config="code ~/.zshrc"
alias zsh_reset="source ~/.zshrc"

# Custom Aliases
alias ls='ls -lAFh'

# Web Dev aliases
alias pnx="pnpm nx"

# Homebrew aliases
alias mbrew="arch -arm64 /opt/homebrew/bin/brew"
alias ibrew="arch -x86_64 /usr/local/bin/brew"

# Eza (better ls)
eza_params=('--git' '--icons' '--classify' '--group-directories-first' '--time-style=long-iso' '--group' '--color-scale')

alias ls='eza $eza_params'
alias l='eza --git-ignore $eza_params'
alias ll='eza --all --header --long $eza_params'
alias llm='eza --all --header --long --sort=modified $eza_params'
alias la='eza -lbhHigUmuSa'
alias lx='eza -lbhHigUmuSa@'
alias lt='eza --tree $eza_params'
alias tree='eza --tree $eza_params'

# Zoxide (better cd)
alias cd="z"

# Git aliases
alias g='git'
# WIP / Stashing methods
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
alias gunwip='git rev-list --max-count=1 --format="%s" HEAD | grep -q "\--wip--" && git reset HEAD~1'

# Shortcuts
alias copyssh="pbcopy < $HOME/.ssh/id_ed25519.pub"
alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
alias c="clear"
alias myip="curl https://ipinfo.io/json" # or /ip for plain-text ip

# Directories
alias dotfiles="cd $DOTFILES"
alias library="cd $HOME/Library"

# Code-server (Docker)
alias code-server="~/Projects/.code-server/manage.sh"
alias codeserver="~/Projects/.code-server/manage.sh"

# Coder (Development Workspaces)
alias coder-start='~/dotfiles-macos/config/coder/manage.sh start'
alias coder-stop='~/dotfiles-macos/config/coder/manage.sh stop'
alias coder-restart='~/dotfiles-macos/config/coder/manage.sh restart'
alias coder-logs='~/dotfiles-macos/config/coder/manage.sh logs'
alias coder-status='~/dotfiles-macos/config/coder/manage.sh status'
alias coder-url='~/dotfiles-macos/config/coder/manage.sh url'