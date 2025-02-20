#!/bin/env bash

### Configuration

source "$HOME/.env"

TOOL_PATH=~/.local/share/obsidian-tool
JOURNAL_VAULT=$(dirname "$JOURNAL")
JOURNAL_VAULT=$(basename "$JOURNAL_VAULT")

if [ ! -f "/tmp/obsidian-workspace" ]; then
  echo "$OBSIDIAN" >/tmp/obsidian-workspace
fi

if [ ! -f "$TOOL_PATH" ]; then
  echo "nvim" >"$TOOL_PATH"
fi

##############################

# keybindings
workspace_mode="Alt+Tab"
select_daily="Alt+s"
today="Alt+a"
tool_mode="Alt+t"
delete="Alt+d"
reset="Alt+q"

# workspace_mode="Ctrl+1"
# select_daily="Ctrl+2"
# today="Ctrl+3"
# tool_mode="Ctrl+t"
# delete="Ctrl+s"
# reset="Ctrl+q"

# colors
help_color="#7c5cff"
label="#f067fc"
div_color="#334433"

_rofi() {
  rofi -dmenu -i -no-levenshtein-sort -width 1000 "$@"
}

deleteMenu() {
  delask=$(echo -e "1. Yes\n2. No" | _rofi -p '> ' -mesg "<span color='${label}'>Really delete</span> <span color='${help_color}'>$menu?</span>")
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
    workspace=$(cat "/tmp/obsidian-workspace")
    workspace_name=$(basename "$workspace")
    notes=$(find "$workspace" -type f -name '*.md' -printf '%P\n' | sed 's/\.md$//')
    menu=$(echo "${notes}" | _rofi -p "$mode/$TOOL" -mesg "${HELP}" -kb-custom-1 "${tool_mode}" -kb-custom-2 "${workspace_mode}" -kb-custom-3 "${select_daily}" -kb-custom-4 "${delete}" -kb-custom-5 "${today}" -kb-custom-6 "${reset}")
    ;;
  workspace)
    menu=$(ls $OBSIDIAN | _rofi -p "$mode/$TOOL" -mesg "${HELP}" -kb-custom-1 "${tool_mode}" -kb-custom-2 "${workspace_mode}" -kb-custom-3 "${select_daily}" -kb-custom-4 "${delete}" -kb-custom-5 "${today}" -kb-custom-6 "${reset}")
    ;;
  daily)
    TOOL=$(cat "$TOOL_PATH")
    folder="$JOURNAL/"
    daily_notes=$(find "$folder" -type f -name '*.md' -printf '%P\n' | sed 's/\.md$//')
    menu=$(echo "${daily_notes}" | _rofi -p "$mode/$TOOL" -mesg "${HELP}" -kb-custom-1 "${tool_mode}" -kb-custom-2 "${workspace_mode}" -kb-custom-3 "${select_daily}" -kb-custom-4 "${delete}" -kb-custom-5 "${today}" -kb-custom-6 "${reset}")
    ;;
  today)
    TOOL=$(cat "$TOOL_PATH")
    menu=$(echo -e "1. Day\n2. Week\n3. Month\n4. Year" | _rofi -p "$mode/$TOOL" -mesg "${HELP}" -kb-custom-1 "${tool_mode}" -kb-custom-2 "${workspace_mode}" -kb-custom-3 "${select_daily}" -kb-custom-4 "${delete}" -kb-custom-5 "${today}" -kb-custom-6 "${reset}")
    ;;
  tool)
    menu=$(echo -e "nvim\nneovide\nobsidian" | _rofi -p "$mode/$TOOL" -mesg "${HELP}" -kb-custom-1 "${tool_mode}" -kb-custom-2 "${workspace_mode}" -kb-custom-3 "${select_daily}" -kb-custom-4 "${delete}" -kb-custom-5 "${today}" -kb-custom-6 "${reset}")
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
      case "$TOOL" in
      nvim) $TERMCMD -e nvim "$workspace/$menu.md" ;;
      neovide) neovide "$workspace/$menu.md" ;;
      obsidian) obsidian-cli open "$menu" --vault "$workspace_name" ;;
      esac
      ;;
    workspace)
      [[ -z "$menu" ]] && notify-send -u low "Obsidian: Error" "No vault selected" && exit
      echo "$OBSIDIAN/$menu" >"/tmp/obsidian-workspace"
      notify-send -u low "Obsidian: Workspaces" "Changed workspaces to $menu"
      mode=notes main
      ;;
    daily)
      [[ -z "$menu" ]] && notify-send -u low "Obsidian: Error" "No vault selected" && exit
      case "$TOOL" in
      "neovim") $TERMCMD -e nvim "$folder/$menu".md ;;
      "neovide") neovide "$folder/$menu".md ;;
      "obsidian") obsidian-cli open "$menu" --vault $JOURNAL ;;
      esac
      ;;
    today)
      [[ -z "$menu" ]] && notify-send -u low "Obsidian: Error" "No note selected" && exit
      case "$menu" in
      "1. Day")
        folder="$JOURNAL/Daily/"
        daily=$(date +%F)
        ;;
      "2. Week")
        folder="$JOURNAL/Week/"
        year_var=$(date +%Y)
        week_var=$(date +%W)
        daily=$(echo "${year_var}-W${week_var}")
        ;;
      "3. Month")
        folder="$JOURNAL/Month/"
        year_var=$(date +%Y)
        month_var=$(date +%B)
        daily=$(echo "${month_var}, "${year_var}"")
        ;;
      "4. Year")
        folder="$JOURNAL/"
        daily=$(date +%Y)
        ;;
      esac
      case "$TOOL" in
      nvim) $TERMCMD -e nvim "$folder/$daily.md" ;;
      neovide) neovide "$folder/$daily.md" ;;
      obsidian) obsidian-cli open "$daily" --vault "$JOURNAL_VAULT" ;;
      *) notify-send -u low "Obsidian: Error" "No available tool" ;;
      esac
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
