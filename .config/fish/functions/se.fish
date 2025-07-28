function se
    set choice "$(find -L ~/.local/bin -printf '%P\n' | fzf)"
    [ -f "$HOME/.local/bin/$choice" ] && $EDITOR "$HOME/.local/bin/$choice"
end
