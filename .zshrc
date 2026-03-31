[[ -f ~/.config/.zsh/aliases.zsh ]] && source ~/.config/.zsh/aliases.zsh
[[ -f ~/.config/.zsh/starship.zsh ]] && source ~/.config/.zsh/starship.zsh

# Load Starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

# # Load Direnv
# eval "$(direnv hook zsh)"

# # Load zoxide
# eval "$(zoxide init zsh)"

# # kubectl krew
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# PROMPT="${PROMPT}"$'\n\n'

. /opt/homebrew/opt/asdf/libexec/asdf.sh
autoload -Uz compinit && compinit

# pnpm
export PNPM_HOME="/Users/toddjudd/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# https://github.com/whiplashmerch/wl
# WL
export PATH="/Users/toddjudd/git/wl/exe:$PATH"
# WL end
