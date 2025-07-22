function fish_prompt
    set_color "#7c5cff"
    echo "$(prompt_pwd --full-length-dirs 2)$(set_color normal)$(set_color "#f4f113") $(fish_git_prompt)"
    set_color "#7c5cff"
    echo '❯' (set_color normal)
end
