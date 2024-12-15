#!/bin/env bash

set -eo pipefail

user=$(whoami)

echo "→ setting up dotfiles"

echo "→ installing stow"

sudo pacman -S stow

cd "$HOME/dotfiles"
stow .
cd

NAME=$1
EMAIL=$2
GPG_KEY=$3

echo "→ setting up git"

sudo pacman -S git

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

echo "→ upgrade and update pacman packages"

sudo pacman -Sy
sudo pacman -Syu

# echo "→ setting up nextdns"

# sh -c "$(curl -sL https://nextdns.io/install)"

echo "→ setting up firewall"

sudo pacman -S ufw

sudo ufw enable

echo "→ setting up flatpak"

sudo pacman -S flatpak
flatpak install io.github.zen_browser.zen
flatpak install com.github.tchx84.Flatseal
flatpak install org.kde.okular

echo "→ setting up yay"

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

echo "→ install essencial packages"

sudo pacman -S rsync gocryptfs pass gvfs mtpfs gvfs-mtp tmux ffmpeg polkit udiskie udisks2 fuse2 kitty mpv fastfetch onefetch unzip zip python-psutil ranger picom scrcpy lynx ddgr nsxiv bpytop direnv eza fd fzf github-cli gnome-keyring networkmanager-openvpn tldr man xwallpaper lazygit task zoxide ripgrep xclip neomutt bat cmatrix figlet tmuxp cmus dmenu gitleaks moreutils redshift

echo "→ install graphical packages"

sudo pacman -S seahorse obsidian libreoffice audacity shotcut handbrake converseen flameshot curtail deltachat-desktop gnome-disk-utility obs-studio gimp

echo "→ install AUR packages"

yay -S qtile-extras
yay -S autokey-gtk
yay -S pet-bin
# yay -S ttf-ms-win10-auto
yay -S cava

echo "→ setting up syncthing"

sudo pacman -S syncthing
sudo systemctl enable syncthing@$USER.service

echo "→ install pip"

sudo pacman -S python3-pip

echo "→ install fonts"

sudo pacman -S noto-fonts-emoji
sudo pacman -S gnu-free-fonts
sudo pacman -S ttf-ubuntu-nerd
sudo pacman -S ttf-dejavu-nerd
sudo pacman -S ttf-jetbrains-mono-nerd

echo "→ install cargo"

sudo pacman -S cargo

echo "→ install PipeWire for audio management"

sudo pacman -S pipewire pipewire-utils

echo "→ install zsh and oh-my-posh"

sudo pacman -S zsh
curl -s https://ohmyposh.dev/install.sh | bash -s

echo "→ installing Neovim"

sudo pacman -S neovim

echo "→ setting zsh as default shell"

cd "$HOME"
sudo chsh -s "$(which zsh)" "$user"
zsh
source "$HOME/.zshrc"

echo "→ applying final configurations"

picom --config "$HOME/.config/picom.conf"
ohmyposh --config "$HOME/.config/ohmyposh/"

echo "→ installation complete"

echo "You may now reboot to apply some settings"
