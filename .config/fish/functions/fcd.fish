# Fzf Change Directory
function fcd --description \
    "Change to directory using fzf"
    cd "$(find "$PWD" -maxdepth 10 -type d 2>/dev/null | fzf)"
end
