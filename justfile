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

# Run install.sh (Arch Linux) >> Unmaintained
install:
  sh "$HOME/dotfiles/install.sh"

# Install TPM
install-tpm:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Fix Arch Linux Keyring if downloaded packages retrieve a gpg corrupt signature
fix-keyring:
  sudo rm -R /etc/pacman.d/gnupg/
  sudo rm -R /root/.gnupg/
  gpg --refresh-keys
  sudo pacman-key --init && sudo pacman-key --populate archlinux

# Install Oh-my-posh
install-posh:
  curl -s https://ohmyposh.dev/install.sh | bash -s

# Change Font
gnome-font:
  gsettings set org.gnome.desktop.interface font-name 'Ubuntu 12'

# Install Invidious
install-invidious:
  docker run quay.io/invidious/youtube-trusted-session-generator
  git clone https://github.com/iv-org/invidious.git
  mv ./invidious.yaml ~/dotfiles/invidious/docker-compose.yml
  echo "Manual changes required. See https://docs.invidious.io/installation/#docker-compose-method-production for details"

# Install X CMD
install-xcmd:
  eval "$(curl https://get.x-cmd.com)"

# Install Doom Emacs
install-doom:
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  ~/.config/emacs/bin/doom install

# Install Termux Packages
install-termux:
  pkg install oh-my-posh zsh fzf direnv python golang ranger yazi zoxide git rclone rsync busybox openssh termux-api cmus tmux curl lazygit exiftool ffmpeg just bat eza git-crypt man mpv ripgrep yt-dlp stow neovim gcc gnupg taskwarrior lynx bc imagemagick timewarrior wget jq

# Install Gemini CLI (reugn/gemini-cli)
install-gemini:
  go install github.com/reugn/gemini-cli/cmd/gemini@latest
