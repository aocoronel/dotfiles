function mountd --description \
    "Guarantee user ownership over mounted drive"
    sudo mount -o uid=$UID,gid="$(id -g)" "/dev/$argv[1]" "/mnt/$argv[2]"
end
