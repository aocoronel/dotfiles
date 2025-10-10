# List recipes (default)
list:
  just --list

# Apply dotfiles
stow:
  stow -R .

# Apply the elegantvagrant theme
neostow:
  neostow -V -o

# Check for git leaks
check:
  gitleaks git

# Install Tmux Package Manager
install-tpm:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Fix Arch Linux Keyring if has a corrupt signature
arch-fix-keyring:
  sudo rm -R /etc/pacman.d/gnupg/
  sudo rm -R /root/.gnupg/
  gpg --refresh-keys
  sudo pacman-key --init && sudo pacman-key --populate archlinux

# Change Font
gnome-font:
  gsettings set org.gnome.desktop.interface font-name 'Ubuntu 12'

# Install Invidious
install-invidious:
  docker run quay.io/invidious/youtube-trusted-session-generator
  git clone https://github.com/iv-org/invidious.git $HOME/invidious
  mv -f ./invidious.yaml ~/invidious/docker-compose.yml
  echo "Manual changes required. See https://docs.invidious.io/installation/#docker-compose-method-production for details"

# Install Doom Emacs
install-doom:
  git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
  ~/.config/emacs/bin/doom install

# Install Termux Packages
install-termux:
  pkg install zsh fzf direnv python golang ranger yazi zoxide git rclone rsync busybox openssh termux-api cmus tmux curl lazygit git ffmpeg just bat eza git-crypt mandoc mpv ripgrep yt-dlp stow neovim gnupg taskwarrior lynx imagemagick timewarrior wget jq fd  moreutils newsboat restic unzip wget pass helix libllvm nodejs

# Install Clipmenu (Xorg)
install-clipmenu:
  git clone https://github.com/cdown/clipmenu.git $HOME/dev/3p/clipmenu

# Install taskwarrior-tui binary for task2
install-task2-tui:
  wget https://github.com/kdheepak/taskwarrior-tui/releases/download/v0.25.4/taskwarrior-tui-x86_64-unknown-linux-gnu.tar.gz
  tar xf taskwarrior-tui-x86_64-unknown-linux-gnu.tar.gz
  rm taskwarrior-tui-x86_64-unknown-linux-gnu.tar.gz
  sudo mv taskwarrior-tui /usr/local/bin/

# Download task2 source code
install-task2:
  wget https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.6.2/task-2.6.2.tar.gz

# Add flathub repository
install-flathub:
  flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install podman in Alpine Linux (root)
alpine-podman:
  rc-update add cgroups
  rc-service cgroups start
  modprobe tun
  echo tun >>/etc/modules
  echo aoc:100000:65536 >/etc/subuid
  echo aoc:100000:65536 >/etc/subgid
  echo -e "#!/bin/sh\nmount --make-rshared /" > /etc/local.d/mount-rshared.start
  chmod +x /etc/local.d/mount-rshared.start
  rc-update add local default
  rc-service local start
  touch /etc/containers/nodocker
