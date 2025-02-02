#!/bin/env bash

set -eo pipefail

# Pacman Packages

bluetooth="blueberry gnome-bluetooth-3.0"
xorg="flameshot sxhkd redshift xwallpaper xclip nsxiv"
wayland="waybar hyprland hyprlang hyprsunset hyprlock hypridle hyprctl cliphist jq xdg-desktop-portal-hyprland cmake meson cpio pkg-config hyprpolkitagent swww hyprpicker wlogout wl-clipboard wf-recorder"

essentials="gvfs mtpfs gvfs-mtp polkit udiskie udisks2 fuse2 unzip zip direnv atomicparsley zsh ueberzugpp gnome-keyring playerctl ydotool brightnessctl"

cli="rsync pass tmux pass-otp gocryptfs ffmpeg mpv cmus onefetch fastfetch lynx ranger bpytop eza fd fzf github-cli tldr man lazygit task taskwarrior-tui zoxide ripgrep bat cmatrix figlet tmuxp cmus gitleaks moreutils navi imagemagick just neomutt syncthing neovim mupdf mupdf-tools yt-dlp newsboat ddgr odt2text"
graphical="seahorse obsidian libreoffice-fresh shotcut gnome-disk-utility obs-studio gimp dmenu dunst neovide kitty foot picom scrcpy rofi-calc rofi networkmanager-openvpn fuzzel swayimg grim slurp satty pavucontrol"

tts="rhvoice rhvoice-language-english rhvoice-voice-lyubov"

lang="rustup npm luarocks"
python="python-pipx python-psutil python-mutagen python-pillow"

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

sudo pacman -S $essentials $cli $graphical $tts $lang $python $tor $wayland

echo "→ install AUR packages"

yay -S buku zen-browser-bin obsidian-cli-bin cava mutt-wizard obfs4proxy freetube-bin

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

echo "Run: just"
