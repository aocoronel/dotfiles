function ranger_cd
    set -l temp_file (mktemp -t ranger_cd.XXXXXXXXXX)
    set -l dir $argv[1]
    if test -z "$dir"
        set dir $PWD
    end
    ranger --choosedir="$temp_file" "$dir"
    set -l chosen_dir (cat $temp_file)
    if test -d $chosen_dir -a -n "$chosen_dir" -a "$chosen_dir" != "$PWD"
        cd $chosen_dir
    end
    rm -f $temp_file
end
