if status is-interactive
    if type -q fzf
        fzf --fish | source
    end
    if type -q zoxide
        zoxide init --cmd cd fish | source
    end
    # if type -q oh-my-posh
    # oh-my-posh init fish | source
    # end
    if type -q direnv
        direnv hook fish | source
    end

    fish_vi_key_bindings

    if test -d ~/.config/fish/fzf.fish
        return 0
    else
        sh "$HOME/.config/fish/install_plugin.sh"
    end

    set FZF_DEFAULT_OPTS $FZF_DEFAULT_OPTS'
  --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#050505,bg+:#262626
  --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
  --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=border:#262626,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'
end
