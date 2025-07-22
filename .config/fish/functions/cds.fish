function cds --description \
    "Return to default Tmux directory"
    local session
    set session $(tmux display-message -p '#{session_path}')
    cd "$session" || return
end
