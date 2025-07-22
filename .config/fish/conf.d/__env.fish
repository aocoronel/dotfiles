# Tools

set -g VISUAL nvim
set -g EDITOR nvim
set -g PAGER bat
set -g MANPAGER "nvim +Man!"
set -g WAYLAND_DISPLAY wayland-1

# PATH

set PATH "$HOME/scripts/" $PATH # Own Scripts
set PATH "$HOME/zscripts/" $PATH # Others Scripts
set PATH "$HOME/.cargo/bin/" $PATH # Rust
set PATH "$HOME/.config/emacs/bin" $PATH # Emacs
set PATH "$HOME/go/bin" $PATH # Golang
set PATH "$HOME/.local/bin/" $PATH # Alternative
set PATH "$HOME/.local/share/gem/ruby/3.3.0/bin" $PATH # Ruby
set PATH "$HOME/.local/share/gem/ruby/3.3.0/gems/" $PATH # Ruby
set PATH /run/wrappers/bin $PATH # NixOS

# Directories

set -g OBSIDIAN $HOME/obsidian/
set -g JOURNAL $OBSIDIAN/journal/Journals/

set -g BEELZEBUB /mnt/beelzebub/
set -g ATLAS /mnt/go/atlas/

set -g DEV "$HOME/dev/"
set -g SCRIPTS "$HOME/scripts/"
set -g PASSWORD_STORE_DIR "$HOME/.password-store/"
