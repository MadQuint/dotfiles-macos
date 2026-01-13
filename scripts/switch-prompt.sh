#!/usr/bin/env bash
# Switch between Powerlevel10k and Starship prompts

ZSHRC="$HOME/.zshrc"

show_current() {
  if grep -q "^eval.*starship init" "$ZSHRC" 2>/dev/null; then
    echo "✨ Current prompt: Starship"
  elif grep -q '^ZSH_THEME="powerlevel10k' "$ZSHRC" 2>/dev/null; then
    echo "⚡ Current prompt: Powerlevel10k"
  else
    echo "❓ Unknown prompt configuration"
  fi
}

to_starship() {
  echo "Switching to Starship..."
  
  # Comment out P10k instant prompt
  sed -i.bak '/^if \[\[ -r.*p10k-instant-prompt/,/^fi/s/^/# /' "$ZSHRC"
  
  # Uncomment Starship init
  sed -i.bak 's/^# eval "\$(starship init zsh)"/eval "$(starship init zsh)"/' "$ZSHRC"
  
  # Set ZSH_THEME to empty
  sed -i.bak 's/^ZSH_THEME="powerlevel10k\/powerlevel10k"/ZSH_THEME=""/' "$ZSHRC"
  
  # Comment out p10k.zsh sourcing
  sed -i.bak 's/^\[\[ ! -f ~\/.p10k.zsh \]\]/# \[\[ ! -f ~\/.p10k.zsh \]\]/' "$ZSHRC"
  
  rm "${ZSHRC}.bak"
  echo "✅ Switched to Starship! Restart your terminal or run: source ~/.zshrc"
}

to_p10k() {
  echo "Switching to Powerlevel10k..."
  
  # Uncomment P10k instant prompt
  sed -i.bak '/^# if \[\[ -r.*p10k-instant-prompt/,/^# fi/s/^# //' "$ZSHRC"
  
  # Comment Starship init
  sed -i.bak 's/^eval "\$(starship init zsh)"/# eval "$(starship init zsh)"/' "$ZSHRC"
  
  # Set ZSH_THEME back
  sed -i.bak 's/^ZSH_THEME=""/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$ZSHRC"
  
  # Uncomment p10k.zsh sourcing
  sed -i.bak 's/^# \[\[ ! -f ~\/.p10k.zsh \]\]/\[\[ ! -f ~\/.p10k.zsh \]\]/' "$ZSHRC"
  
  rm "${ZSHRC}.bak"
  echo "✅ Switched to Powerlevel10k! Restart your terminal or run: source ~/.zshrc"
}

case "$1" in
  starship|s)
    to_starship
    ;;
  p10k|powerlevel10k|p)
    to_p10k
    ;;
  current|c)
    show_current
    ;;
  *)
    echo "Prompt Switcher"
    echo ""
    show_current
    echo ""
    echo "Usage: $0 {starship|p10k|current}"
    echo ""
    echo "Commands:"
    echo "  starship, s          Switch to Starship prompt"
    echo "  p10k, p              Switch to Powerlevel10k prompt"
    echo "  current, c           Show current prompt"
    exit 1
    ;;
esac
