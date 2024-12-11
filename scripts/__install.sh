#!/bin/env bash

set -eo pipefail

echo "→ update and upgrade pacman packages"

sudo pacman -Sy 
sudo pacman -Syu

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

echo "→ setting up nextdns"

sh -c "$(curl -sL https://nextdns.io/install)"

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

sudo pacman -S kitty git rsync gocryptfs keepassxc gvfs mtpfs gvfs-mtp tmux tumbler ffmpeg ffmpegthumbnailer polkit udiskie udisks2 fuse2 mpv fastfetch onefetch unzip python-psutil ranger picom scrcpy lynx ddgr nsxiv bpytop direnv exa fd fzf github-cli gnome-keyring w3m networkmanager-openvpn eza starship tldr xwallpaper just zoxide task

sudo pacman -S python3-setuptools figlet pydf wget mtr ncdu cmatrix jq lolcat locate libgraph-easy-perl stow cowsay fortune

sudo pacman -S xclip xsel alsa-utils expect bat openvpn

echo "→ install graphical packages"

sudo pacman -S obsidian libreoffice audacity shotcut handbrake converseen flameshot curtail deltachat-desktop gnome-disk-utility obs-studio gimp

echo "→ install AUR packages"

yay -S qtile-extras
yay -S autokey-gtk
yay -S pet-bin
yay -S ttf-ms-win10-auto
yay -S tmuxinator
yay -S cava

echo "→ install pip"

sudo pacman -S python3-pip

echo "→ install fonts"

sudo pacman -S noto-fonts-emoji 
sudo pacman -S ttf-ubuntu-nerd
sudo pacman -S ttf-dejavu-nerd
sudo pacman -S gnu-free-fonts

echo "→ Install cargo"

sudo pacman -S cargo

echo "→ install zsh and oh-my-zsh"

sudo pacman -S zsh
sudo rm -rf ~/.oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "→ Installing zsh-autosuggestions plugin"

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "→ Installing Neovim"

sudo pacman -S neovim

echo "→ Setting zsh as default shell"

cd "$HOME"
sudo chsh -s $(which zsh) "$user"
zsh
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="3den"/g' ~/.zshrc
source ~/.zshrc
exec zsh

echo "→ Installation complete"
