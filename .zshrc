# Plugins

## Zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
() { source "${ZINIT_HOME}/zinit.zsh" }

## Plugins

zinit ice depth=1
zinit ice lucid wait"0"
zinit light zsh-users/zsh-syntax-highlighting
zinit ice lucid wait"0"
zinit light zsh-users/zsh-completions
zinit ice lucid wait"0"
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions
zinit ice lucid wait"0"
zinit light jeffreytse/zsh-vi-mode
zinit ice lucid wait"0"
zinit light MichaelAquilina/zsh-you-should-use

## oh-my-zsh

zinit ice lucid wait"0"
zinit snippet OMZP::eza
zinit snippet OMZP::gpg-agent
zinit ice lucid wait"0"
zinit snippet OMZP::taskwarrior
zinit ice lucid wait"0"
zinit snippet OMZP::cp
zinit ice lucid wait"0"
zinit snippet OMZP::nmap
zinit ice lucid wait"0"
zinit snippet OMZP::rsync

# Sources

source "$HOME/.shalias"              # Aliases
source "$HOME/.env"                  # Environment variables
source "$HOME/.shfunction"           # Functions
source "$HOME/.secrets"              # Env Secrets

# Tools

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
# eval "$(navi widget zsh)"
# eval "$(starship init zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/elegantvagrant.omp.toml)"
eval "$(direnv hook zsh)"

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --color=fg:#d0d0d0,fg+:#d0d0d0,bg:#050505,bg+:#262626
  --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
  --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
  --color=border:#262626,label:#aeaeae,query:#d9d9d9
  --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
  --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

# Config

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

# Completions

autoload -U compinit;
compinit -C

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh/zcompcache
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --style=numbers $realpath'

# Keybindings

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

function kill_tmux_pane() {
  tmux kill-pane
}

zle -N kill_tmux_pane
bindkey '^[t' kill_tmux_pane

if [ "$RANGERCD" = true ]; then unset RANGERCD; ranger_cd; fi
