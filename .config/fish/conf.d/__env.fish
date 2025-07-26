# Tools

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx PAGER bat
set -gx MANPAGER "nvim +Man!"
# set -gx WAYLAND_DISPLAY wayland-1

# PATH

set PATH "$(find -L ~/.local/bin -type d | paste -sd ':' -)" $PATH # All subdirectories
set PATH "$HOME/.cargo/bin/" $PATH # Rust
set PATH "$HOME/.config/emacs/bin" $PATH # Emacs
set PATH "$HOME/.config/sxhkd/" $PATH # Sxhkd
set PATH "$HOME/go/bin" $PATH # Golang
set PATH "$HOME/.local/bin/" $PATH # Alternative
set PATH "$HOME/.local/share/gem/ruby/3.3.0/bin" $PATH # Ruby
set PATH "$HOME/.local/share/gem/ruby/3.3.0/gems/" $PATH # Ruby
set PATH /run/wrappers/bin $PATH # NixOS

# Directories

set -gx XDG_CONFIG_HOME "$HOME/.config"

set -gx PASSWORD_STORE_DIR "$HOME/.password-store/"

set -gx DEV "$HOME/dev/"
set -gx GO_PATH "$DEV/go/"

set -gx REPOX_FILE "$HOME/.local/share/repox"

set -gx OBSIDIAN "$HOME/obsidian/"
set -gx JOURNAL "$OBSIDIAN/journal/Journals/"
