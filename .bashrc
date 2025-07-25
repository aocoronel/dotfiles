# ~/.bashrc
[[ $- != *i* ]] && return

HISTTIMEFORMAT="%F %T "

set -o vi

source "$HOME/.config/env"
source "$HOME/.config/secrets"
source "$HOME/.config/shalias"
source "$HOME/.config/shfunction"

eval "$(fzf --bash)"
eval "$(zoxide init bash)"
# eval "$(starship init bash)"
eval "$(direnv hook bash)"
