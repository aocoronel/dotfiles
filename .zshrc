# === Prompt ===

# CWD        Shell Symbol                                     Git Branch
# ~/dotfiles ❯                                                (main)

# Builtin zsh prompt
PROMPT='%B%F{99}%2~ %(!.#.❯)%f%b '
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{11}(%b)%f'
zstyle ':vcs_info:*' enable git

# === Plugins ===

# I do use few plugins, so I made my own package manager

# Define GitHub repositories
plugins=(
  "Aloxaf/fzf-tab"
  "jeffreytse/zsh-vi-mode"
  "olets/zsh-transient-prompt"
  "zsh-users/zsh-autosuggestions"
  "zsh-users/zsh-completions"
  "zsh-users/zsh-syntax-highlighting"
)

plugin_dir="$HOME/.local/share/zsh/"
[ ! -d "$plugin_dir" ] && mkdir -p "$plugin_dir"

for plugin in ${plugins[@]}; do
  [ ! -d "$plugin_dir/$plugin" ] && git clone https://github.com/$plugin \
    --single-branch --depth 1 "$plugin_dir/$plugin"
done

# Taskwarrior Hook
# This will patch the _task file to make the "proj:TAB" functionality to show
# all projects, instead of only pending ones
[ ! -d "$plugin_dir/task" ] && {
  mkdir "$plugin_dir/task"
  curl \
    https://raw.githubusercontent.com/GothenburgBitFactory/taskwarrior/refs/heads/develop/scripts/zsh/_task \
    -o "$plugin_dir/task/_task"
  sed -i \
    "s/task rc.hooks=0 _projects/task rc.list.all.projects=1 rc.hooks=0 _projects/" \
    "$plugin_dir/task/_task"
}

# Define the look of the transient prompt
export TRANSIENT_PROMPT_TRANSIENT_PROMPT='%B%F{10}❯%b%f '
export TRANSIENT_PROMPT_TRANSIENT_RPROMPT=''

# Source each plugin manually
source $plugin_dir/olets/zsh-transient-prompt/transient-prompt.plugin.zsh
source $plugin_dir/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source $plugin_dir/zsh-users/zsh-completions/zsh-completions.plugin.zsh
source $plugin_dir/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source $plugin_dir/Aloxaf/fzf-tab/fzf-tab.plugin.zsh
source $plugin_dir/jeffreytse/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# === Completions ===

fpath=("$plugin_dir/task/" $fpath)

# Drop plugins and plugin_dir variables
unset plugins plugin_dir

autoload -U compinit;
compinit -C
compdef _task t=task

zstyle ':completion:*:*:task:*' verbose yes
zstyle ':completion:*:*:task:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:*:task:*' group-name ''

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --style=numbers $realpath'

# === Source External Files ===

source "$HOME/.config/env"        # Environment variables
source "$HOME/.config/secrets"    # Env Secrets (not version controlled)
source "$HOME/.config/shalias"    # Aliases
source "$HOME/.config/shfunction" # Functions

# === Tools Integration ===

eval "$(direnv hook zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# === Themes ===

# eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/elegantvagrant.omp.toml)"
# eval "$(starship init zsh)"

# === Customize FZF ===

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#050505,bg+:#262626
  --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
  --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=border:#262626,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

# === Zsh Options ===

HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# === Keybindings ===

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

function kill_tmux_pane() {
  tmux kill-pane
}

# Alt + t: Kills tmux pane
zle -N kill_tmux_pane
bindkey '^[t' kill_tmux_pane

# === Ranger Integration ===

if [ "$RANGERCD" = true ]; then unset RANGERCD; ranger_cd; fi
