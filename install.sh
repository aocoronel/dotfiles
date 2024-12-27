#!/bin/env bash

set -eo pipefail

user=$(whoami)

echo "→ setting up dotfiles"

echo "→ installing stow"

sudo pacman -S stow

cd "$HOME/dotfiles"
stow .
cd

GPG_KEY=$1

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

# echo "→ setting up flatpak"

# sudo pacman -S flatpak
# flatpak install io.github.zen_browser.zen
# flatpak install com.github.tchx84.Flatseal
# flatpak install org.kde.okular

echo "→ setting up yay"

sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

echo "→ install essencial packages"

sudo pacman -S rsync gocryptfs pass pass-otp gvfs mtpfs gvfs-mtp tmux ffmpeg polkit udiskie udisks2 fuse2 kitty mpv fastfetch onefetch unzip zip python-psutil ranger picom scrcpy lynx ddgr nsxiv bpytop direnv eza fd fzf github-cli gnome-keyring networkmanager-openvpn tldr man xwallpaper lazygit task taskwarrior-tui zoxide ripgrep xclip bat cmatrix figlet tmuxp cmus gitleaks moreutils redshift python-mutagen atomicparsley yt-dlp newsboat sxhkd navi imagemagick just less openssl-1.1

# sudo pacman -S neomutt

echo "→ install graphical packages"

sudo pacman -S seahorse obsidian libreoffice-fresh shotcut handbrake flameshot gnome-disk-utility obs-studio gimp rofi dmenu dunst neovide

# Other packages
# sudo pacman -S audacity curtail

echo "→ install AUR packages"

yay -S qtile-extras
yay -S pet-bin
yay -S buku
yay -S zen-browser-bin
yay -S obsidian-cli-bin
yay -S cava

echo "→ install LSP"

sudo pacman -S luarocks

echo "→ install Tor packages"

sudo pacman -S tor nyx
yay -S obfs4proxy

echo "→ setting up syncthing"

sudo pacman -S syncthing
sudo systemctl enable syncthing@$USER.service

# echo "→ install pip"
#
# sudo pacman -S python3-pip

echo "→ install fonts"

sudo pacman -S noto-fonts-emoji gnu-free-fonts ttf-ubuntu-nerd ttf-dejavu-nerd ttf-jetbrains-mono-nerd

# Microsoft Fonts
# Once it's installed the fonts are saved to /usr/fonts and can be exported,
# removing the necessity to install this every fresh install
# yay -S ttf-ms-win10-auto

# echo "→ install cargo"
#
# sudo pacman -S cargo

# echo "→ install PipeWire"
#
# sudo pacman -S pipewire

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

echo "→ installation complete"

echo "You may now reboot to apply some packages and fonts"

echo "→ How to apply final configurations"

echo "picom --config "$HOME/.config/picom.conf""
echo "ohmyposh --config "$HOME/.config/ohmyposh/""
echo "kitty --config "$HOME/.config/kitty/kitty.conf""
