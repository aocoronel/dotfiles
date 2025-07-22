# Repo Fetch
function rf --description \
    "Fetch all development directories using onefetch"
    local repo
    set repo $(fd . $DEV/**/ --type=directory --max-depth 1 --color always | fzf --ansi --preview "onefetch {}" --preview-window up)
    if test -n "$repo"
        cd "$repo" || return
    else
        echo "No repository selected"
    end
end
