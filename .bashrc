# Do not load if interactive
[[ $- != *i* ]] && return

# Simple prompt
export PS1='\w \$ '

# YYYY-MM-DD HH:MM:SS
HISTTIMEFORMAT="%F %T "

source "$HOME/.config/env"
source "$HOME/.config/secrets"
source "$HOME/.config/shalias"

eval "$(direnv hook bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
