#!/bin/env bash

set -eo pipefail

essentials="rsync gocryptfs pass pass-otp gvfs mtpfs gvfs-mtp tmux ffmpeg polkit udiskie udisks2 fuse2 mpv fastfetch onefetch unzip zip python-psutil ranger picom scrcpy lynx ddgr nsxiv bpytop direnv eza fd fzf github-cli gnome-keyring networkmanager-openvpn tldr man xwallpaper lazygit task taskwarrior-tui zoxide ripgrep xclip bat cmatrix figlet tmuxp cmus gitleaks moreutils redshift python-mutagen atomicparsley yt-dlp newsboat sxhkd navi imagemagick just less openssl-1.1 neomutt syncthing rustup zsh neovim ueberzug ghostty npm"
graphical="seahorse obsidian libreoffice-fresh shotcut handbrake flameshot gnome-disk-utility obs-studio gimp rofi dmenu dunst neovide"
lsp="luarocks"
tor="tor nyx"

user=$(whoami)

echo "→ upgrade and update pacman packages"

sudo pacman -Sy
sudo pacman -Syu

echo "→ installing must have packages"

sudo pacman -S stow git ufw

echo "→ setting up firewall"

sudo ufw enable

echo "→ setting up dotfiles"

cd "$HOME/dotfiles"
stow .
cd

GPG_KEY=$1

echo "→ setting up git"

if [ -z "$NAME" ]; then
	read -r -p "Please enter your git user.name" NAME
	NAME=${NAME:-"Augusto Coronel"}
fi

if [ -z "$EMAIL" ]; then
	read -r -p "Please enter your git user.email" EMAIL
	EMAIL=${EMAIL:-"aocoronel@particular.slmail.me"}
fi

if [ -z "$GPG_KEY" ]; then
	git config --global user.signingkey "$GPG_KEY"
	git config --global commit.gpgsign true
	git config --global core.excludesFile "$HOME"/.gitignore
fi

git config --global user.name "$NAME"
git config --global user.email "$EMAIL"

echo "→ setting up yay"

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

echo "→ install pacman packages"

sudo pacman -S $essentials $graphical $tor $lsp

echo "→ install AUR packages"

yay -S qtile-extras pet-bin buku zen-browser-bin obsidian-cli-bin cava mutt-wizard obfs4proxy

echo "→ setting up syncthing"

sudo systemctl enable syncthing@$USER.service

echo "→ install fonts"

sudo pacman -S noto-fonts-emoji gnu-free-fonts ttf-ubuntu-nerd ttf-dejavu-nerd ttf-jetbrains-mono-nerd

# Microsoft Fonts
# Once it's installed the fonts are saved to /usr/fonts and can be exported,
# removing the necessity to install this every fresh install
# yay -S ttf-ms-win10-auto

echo "→ setting zsh as default shell"

cd "$HOME"
sudo chsh -s "$(which zsh)" "$user"
zsh
source "$HOME/.zshrc"

echo "→ install oh-my-posh"

curl -s https://ohmyposh.dev/install.sh | bash -s

echo "→ installation complete"

echo "You may now reboot to apply some packages and fonts"

echo "→ How to apply final configurations"

echo "just config-picom"
echo "just config-posh"
echo "just config-kitty"
echo "just config-udiskie"
