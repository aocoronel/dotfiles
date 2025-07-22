# Change System Volume: changevol 100%
function changevol --description \
    "Change system volume"
    local vol
    set vol $argv
    pactl set-sink-volume @DEFAULT_SINK@ "$vol"
end
