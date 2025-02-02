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

# Install Media Watcher for Activity Watch
config-aw-media:
  git clone https://github.com/2e3s/aw-watcher-media-player.git
  cd aw-watcher-media-player
  sudo unzip -j aw-watcher-media-player-linux.zip aw-watcher-media-player -d /usr/local/bin

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

# Install Oh-my-posh
install-posh:
  curl -s https://ohmyposh.dev/install.sh | bash -s

# Change Font
font:
  gsettings set org.gnome.desktop.interface font-name 'Ubuntu 12'
