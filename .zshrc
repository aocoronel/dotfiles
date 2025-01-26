# Plugins

## Zinit

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

## Plugins

zinit ice depth=1
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light zsh-users/zsh-autosuggestions

## oh-my-zsh

zinit snippet OMZP::eza
zinit snippet OMZP::taskwarrior
zinit snippet OMZP::gpg-agent

# Sources

source "$HOME/.shalias"              # Aliases
source "$HOME/.env"                  # Environment variables
source "$HOME/.shfunction"           # Functions

# Tools

eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(navi widget zsh)"
# eval "$(starship init zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/ohmyposh/elegantvagrant.omp.toml)"
eval "$(direnv hook zsh)"

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

autoload -U compinit; compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 $realpath'
zstyle ':fzf-tab:complete:bat:*' fzf-preview 'bat --style=numbers $realpath'

# Keybindings

bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
