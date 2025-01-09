# Default just
list:
  just --list
# Run stow
stow:
  stow -R .
# Check for git leaks
check:
  gitleaks git
# Config picom: Set config file
config-picom:
  picom --config "$HOME/.config/picom.conf"
# Config oh-my-posh: Set config file
config-posh:
  oh-my-posh --config "$HOME/.config/picom.conf"
# Setup Udiskie: Create file to /etc/polkit-1/rules.d/50-udiskie.rules
config-udiskie:
  sh "$HOME/scripts/__setup-udiskie.sh"
# Set kitty configuration file
config-kitty:
  kitty --config "$HOME/.config/kitty/kitty.conf"
# Run install.sh
install:
  sh "$HOME/dotfiles/install.sh"
# Install TPM
config-tmux:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
