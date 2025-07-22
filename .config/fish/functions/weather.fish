# Use https://github.com/chubin/wttr.in
function weather --description \
    "Forecast using wttr.in"
    curl http://wttr.in/"$argv"
end
