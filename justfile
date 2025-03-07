# Default just
list:
  just --list

# Run stow
stow:
  stow -R .

# Check for git leaks
check:
  gitleaks git

# Config picom: Set config file (Xorg-only)
config-picom:
  picom --config "$HOME/.config/picom.conf"

# Config oh-my-posh: Set config file
config-posh:
  oh-my-posh --config "$HOME/.config/picom.conf"

# Setup Udiskie: Create file to /etc/polkit-1/rules.d/50-udiskie.rules
config-udiskie:
  sh "$HOME/scripts/__setup-udiskie.sh"

# Config kitty: Set config file
config-kitty:
  kitty --config "$HOME/.config/kitty/kitty.conf"

# Run install.sh
install:
  sh "$HOME/dotfiles/install.sh"

# Install TPM
config-tmux:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Fix Arch Linux Keyring if downloaded packages retrieve a gpg corrupt signature
fix-keyring:
  sudo rm -R /etc/pacman.d/gnupg/
  sudo rm -R /root/.gnupg/
  gpg --refresh-keys
  sudo pacman-key --init && sudo pacman-key --populate archlinux

# Add Python packages
pip-extra:
  pipx install bandcamp-dl
  pipx install md2anki
  pipx install khard

# Install Oh-my-posh
install-posh:
  curl -s https://ohmyposh.dev/install.sh | bash -s

# Change Font
gnome-font:
  gsettings set org.gnome.desktop.interface font-name 'Ubuntu 12'

# Install Invidious
invidious:
  docker run quay.io/invidious/youtube-trusted-session-generator
  git clone https://github.com/iv-org/invidious.git
  mv ./invidious.yaml ~/dotfiles/invidious/docker-compose.yml
  echo "Manual changes required. See https://docs.invidious.io/installation/#docker-compose-method-production for details"

# Install X CMD
config-xcmd:
  eval "$(curl https://get.x-cmd.com)"

# Taskwarrior TUI for V2
taskwarrior-tui:
  xdg-open https://github.com/kdheepak/taskwarrior-tui/releases/tag/v0.25.4
