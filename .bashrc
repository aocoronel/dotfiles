# ~/.bashrc
[[ $- != *i* ]] && return

HISTTIMEFORMAT="%F %T "

set -o vi

source $HOME/.bashaliases
source $HOME/.bashenv

eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
eval "$(direnv hook bash)"
