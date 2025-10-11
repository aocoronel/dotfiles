COLOR_YELLOW="$(tput setaf 226)"
COLOR_RED="$(tput setaf 196)"
COLOR_GREEN="$(tput setaf 82)"
COLOR_BLUE="$(tput setaf 87)"
COLOR_RESET=$(tput sgr0)

printfc() {
  mode=$1
  case $mode in
  "ERROR" | "FATAL")
    color="$COLOR_RED"
    ;;
  "WARN")
    mode="WARNING"
    color="$COLOR_YELLOW"
    ;;
  "DEBUG")
    color="$COLOR_BLUE"
    ;;
  "INFO")
    color="$COLOR_GREEN"
    ;;
  esac
  text=$2
  printf "%s[%s]:%s %s\n" "${color}" "${mode}" "${COLOR_RESET}" "${text}"
}
