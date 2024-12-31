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
