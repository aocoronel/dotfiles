# Yazi Shell Integration - Moves to last directory yazi exits
function y
    set -l temp_file (mktemp -t yazi-cdw.XXXXXX)
    if test -z "$argv"
        set dir "$PWD"
    else
        set dir "$argv"
    end
    yazi "$dir" --cwd-file="$temp_file"
    if test -f $temp_file
        set -l chosen_dir (cat $temp_file)
        if test -d "$chosen_dir" -a -n "$chosen_dir" -a "$chosen_dir" != "$PWD"
            builtin cd "$chosen_dir"
        end
    end
    rm -f $temp_file
end
