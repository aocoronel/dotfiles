# ~/.bashrc
[[ $- != *i* ]] && return

export PS1='\w \$ '

HISTTIMEFORMAT="%F %T "

set -o vi

source "$HOME/.config/env"
source "$HOME/.config/secrets"
source "$HOME/.config/shalias"
source "$HOME/.config/shfunction"

# eval "$(oh-my-posh init bash --config ~/.config/ohmyposh/elegantvagrant.omp.toml)"
# eval "$(starship init bash)"
eval "$(direnv hook bash)"
eval "$(fzf --bash)"
eval "$(zoxide init bash)"
