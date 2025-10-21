# Do not load if interactive
[[ $- != *i* ]] && return

# Simple prompt
export PS1='\w \$ '

# Bash History Format
HISTTIMEFORMAT="%F %T "

# VI mode
set -o vi

source "$HOME/.config/env"
source "$HOME/.config/secrets"
source "$HOME/.config/shalias"
source "$HOME/.config/shfunction"

eval "$(direnv hook bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"

# === Themes ===

# eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/elegantvagrant.omp.toml)"
# eval "$(starship init bash)"
