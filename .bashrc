# ~/.bashrc
[[ $- != *i* ]] && return

HISTTIMEFORMAT="%F %T "

set -o vi

source $HOME/.shalias
source $HOME/.env
source $HOME/.shfunction

eval "$(fzf --bash)"
eval "$(zoxide init bash)"
eval "$(starship init bash)"
eval "$(direnv hook bash)"

[ ! -f "$HOME/.x-cmd.root/X" ] || . "$HOME/.x-cmd.root/X" # boot up x-cmd.
