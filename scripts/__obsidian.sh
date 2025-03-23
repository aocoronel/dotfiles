#!/usr/bin/env bash

# https://github.com/aocoronel/dotfiles/blob/main/scripts/__obsidian.sh

### Configuration

## Get Environment Variables

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
source "$SCRIPT_DIR/lib/get_env.sh"

get_obsidian
get_journal
get_term

if [ -z "$JOURNAL" ]; then
  echo "Error: JOURNAL env at .localenv not found"
  exit 1
elif [ -z "$OBSIDIAN" ]; then
  echo "Error: OBSIDIAN env at .localenv not found"
  exit 1
elif [ -z "$TERMCMD" ]; then
  echo "Error: TERMCMD env at .localenv not found"
  exit 1
fi

TOOL_PATH=~/.local/share/obsidian-tool
JOURNAL_VAULT=$(dirname "$JOURNAL")
JOURNAL_VAULT=$(basename "$JOURNAL_VAULT")

if [ ! -f "/tmp/obsidian-workspace" ]; then
  touch /tmp/obsidian-workspace
fi

if [ ! -f "$TOOL_PATH" ]; then
  echo "nvim" >"$TOOL_PATH"
fi

##############################

# keybindings
# workspace_mode="Alt+Tab"
# select_daily="Alt+s"
# today="Alt+a"
# tool_mode="Alt+t"
# delete="Alt+d"
# reset="Alt+q"

workspace_mode="Ctrl+1"
select_daily="Ctrl+2"
today="Ctrl+3"
tool_mode="Ctrl+t"
delete="Ctrl+s"
reset="Ctrl+q"

# colors
help_color="#7c5cff"
label="#f067fc"
div_color="#334433"

_rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000 -p "$mode/$TOOL" -mesg "${HELP}" -kb-custom-1 "${tool_mode}" -kb-custom-2 "${workspace_mode}" -kb-custom-3 "${select_daily}" -kb-custom-4 "${delete}" -kb-custom-5 "${today}" -kb-custom-6 "${reset}" "$@"
}

open() {
  if [ "$mode" == "daily" ] || [ "$mode" == "today" ]; then
    case "$TOOL" in
    "neovim") $TERMCMD -e nvim "$obsidian_directory/$menu".md ;;
    "neovide") neovide "$obsidian_directory/$menu".md ;;
    "obsidian") obsidian-cli open "$menu" --vault $JOURNAL_VAULT ;;
    *) notify-send -u low "Obsidian: Error" "No available tool" ;;
    esac
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
      pgrep "$TOOL" && hyprctl dispatch focuswindow class:"$TOOL"
    fi
  else
    case "$TOOL" in
    "neovim") $TERMCMD -e nvim "$obsidian_directory/$menu".md ;;
    "neovide") neovide "$obsidian_directory/$menu".md ;;
    "obsidian") obsidian-cli open "$menu" --vault $obsidian_file ;;
    *) notify-send -u low "Obsidian: Error" "No available tool" ;;
    esac
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
      pgrep "$TOOL" && hyprctl dispatch focuswindow class:"$TOOL"
    fi
  fi
}

deleteMenu() {
  delask=$(echo -e "1. Yes\n2. No" | _rofi -dmenu -i -no-levenshtein-sort -width 1000 -p '> ' -mesg "<span color='${label}'>Really delete</span> <span color='${help_color}'>$menu?</span>")
  [[ $? -eq 1 ]] && exit
  if [[ "$delask" == "1. Yes" ]]; then
    rm -f "$workspace/$menu.md"
    notify-send -u normal "Obsidian: Delete" "Deleted $menu"
  fi
  mode=notes main
}

main() {
  HELP="<span color='${label}'>Modes: </span><span color='${help_color}'>${workspace_mode}</span>: Toggle Workspace <span color='${div_color}'>|</span> <span color='${help_color}'>${select_daily}</span>: Daily Notes <span color='${div_color}'>|</span> <span color='${help_color}'>${today}</span>: Today Note
<span color='${label}'>Actions: </span><span color='${help_color}'>${delete}</span>: Delete <span color='${div_color}'>|</span> <span color='${help_color}'>${tool_mode}</span>: Change Tools  <span color='${div_color}'>|</span> <span color='${help_color}'>${reset}</span>: Return"

  case "$mode" in
  notes)
    TOOL=$(cat "$TOOL_PATH")
    obsidian_directory=$(cat "/tmp/obsidian-workspace")
    obsidian_file=$(basename "$obsidian_directory")
    notes=$(find "$obsidian_directory" -type f -name '*.md' -printf '%P\n' | sed 's/\.md$//')
    menu=$(echo "${notes}" | _rofi)
    ;;
  workspace)
    menu=$(ls $OBSIDIAN | _rofi)
    ;;
  daily)
    obsidian_directory="$JOURNAL/"
    obsidian_file=$(find "$obsidian_directory" -type f -name '*.md' -printf '%P\n' | sed 's/\.md$//')
    menu=$(echo "${obsidian_file}" | _rofi)
    ;;
  today)
    menu=$(echo -e "1. Day\n2. Week\n3. Month\n4. Year" | _rofi)
    ;;
  tool)
    menu=$(echo -e "nvim\nneovide\nobsidian" | _rofi)
    ;;
  esac

  val=$?
  case "$val" in
  1) exit ;;
  12) mode=daily main ;;
  10) mode=tool main ;;
  13) deleteMenu ;;
  14) mode=today main ;;
  15) mode=notes main ;;
  11)
    case "$mode" in
    notes | workspace | daily | today | tool) mode=workspace ;;
    *) mode=notes ;;
    esac
    main
    ;;
  0)
    case "$mode" in
    notes)
      [[ -z "$menu" ]] && notify-send -u low "Obsidian: Error" "No note selected" && exit
      open
      ;;
    workspace)
      [[ -z "$menu" ]] && notify-send -u low "Obsidian: Error" "No vault selected" && exit
      echo "$OBSIDIAN/$menu" >"/tmp/obsidian-workspace"
      notify-send -u low "Obsidian: Workspaces" "Changed workspaces to $menu"
      mode=notes main
      ;;
    daily)
      [[ -z "$menu" ]] && notify-send -u low "Obsidian: Error" "No vault selected" && exit
      open
      ;;
    today)
      [[ -z "$menu" ]] && notify-send -u low "Obsidian: Error" "No note selected" && exit
      case "$menu" in
      "1. Day")
        obsidian_directory="$JOURNAL/Daily/"
        obsidian_file=$(date +%F)
        ;;
      "2. Week")
        obsidian_directory="$JOURNAL/Week/"
        year_var=$(date +%Y)
        week_var=$(date +%W)
        week=$(date -d "$week_var +7 day" '+%U')
        obsidian_file=$(echo "${year_var}-W${week}")
        ;;
      "3. Month")
        obsidian_directory="$JOURNAL/Month/"
        year_var=$(date +%Y)
        month_var=$(date +%B)
        obsidian_file=$(echo "${month_var}, "${year_var}"")
        ;;
      "4. Year")
        obsidian_directory="$JOURNAL"
        obsidian_file=$(date +%Y)
        ;;
      esac
      open
      ;;
    tool)
      echo "$menu" >"$TOOL_PATH"
      mode=notes main
      ;;
    esac
    ;;
  esac
}

mode=notes
main
