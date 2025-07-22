# Tmuxp Attacher
function tp --description \
    "Enter in a tmuxp profile"
    local session select
    set session $(find "$HOME/.config/tmuxp/" -type f -name '*.yaml' -printf '%P\n' | awk -F. '{print $1}')
    set select $(echo "$session" | fzf --tmux "$argv")
    if tmux has-session -t "$select"
        tmux attach-session -t "$select"
    else
        tmuxp load "$select"
    end
end
