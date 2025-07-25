function se()
    set choice "$(find ~/.local/bin -mindepth 1 -printf '%P\n' | fzf)"
    [ -f "$HOME/.local/bin/$choice" ] && $EDITOR "$HOME/.local/bin/$choice"
end
