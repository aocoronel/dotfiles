# List recipes (default)
list:
  just --list

# Apply dotfiles
stow:
  stow -R .

# Check for git leaks
check:
  gitleaks git

# Install Tmux Package Manager
install-tpm:
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Fix Arch Linux Keyring if has a corrupt signature
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
  git clone https://github.com/iv-org/invidious.git $HOME/invidious
  mv -f ./invidious.yaml ~/invidious/docker-compose.yml
  echo "Manual changes required. See https://docs.invidious.io/installation/#docker-compose-method-production for details"

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

# Install Clipmenu
install-clipmenu:
  git clone https://github.com/cdown/clipmenu.git $HOME/dev/3p/clipmenu

# Install taskwarrior-tui binary for task2
install-taskwarrior-tui-2v:
  wget https://github.com/kdheepak/taskwarrior-tui/releases/download/v0.25.4/taskwarrior-tui-x86_64-unknown-linux-gnu.tar.gz
  tar xf taskwarrior-tui-x86_64-unknown-linux-gnu.tar.gz
  rm taskwarrior-tui-x86_64-unknown-linux-gnu.tar.gz
  sudo mv taskwarrior-tui /usr/local/bin/

# Download task2 source code
install-task2:
  wget https://github.com/GothenburgBitFactory/taskwarrior/releases/download/v2.6.2/task-2.6.2.tar.gz
