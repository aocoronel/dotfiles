# === Prompt ===

# CWD        Shell Symbol                Git Branch
# ~/dotfiles ❯                           (main)

# Builtin zsh prompt
PROMPT='%B%F{99}%2~ %(!.#.❯)%f%b '
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT=\$vcs_info_msg_0_
zstyle ':vcs_info:git:*' formats '%F{11}(%b)%f'
zstyle ':vcs_info:*' enable git

# === Source External Files ===

source "$HOME/.config/env"        # Environment variables
source "$HOME/.config/secrets"    # Env Secrets (not version controlled)
source "$HOME/.config/shalias"    # Aliases

# === Tools Integration ===

eval "$(direnv hook zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# === Zsh Options ===

HISTSIZE=5000
HISTFILE=~/.cache/zsh_history
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

# Drop plugins and plugin_dir variables
unset plugins plugin_dir

# === Completions ===

autoload -U compinit;
compinit -C

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --style=numbers $realpath'
