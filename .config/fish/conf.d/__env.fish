# Tools

set -gx VISUAL nvim
set -gx EDITOR nvim
set -gx PAGER bat
set -gx MANPAGER "nvim +Man!"
set -gx WAYLAND_DISPLAY wayland-1

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

set -gx OBSIDIAN $HOME/obsidian/
set -gx JOURNAL $OBSIDIAN/journal/Journals/

set -gx BEELZEBUB /mnt/beelzebub/
set -gx ATLAS /mnt/go/atlas/

set -gx DEV "$HOME/dev/"
set -gx SCRIPTS "$HOME/scripts/"
set -gx PASSWORD_STORE_DIR "$HOME/.password-store/"
