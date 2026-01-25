.PHONY: list setup stow check arch-fix-keyring install-invidious setup-termux install-clipmenu setup-flathub clone-elegantvagrant clone-nvim submodule

list:
	@echo "arch-fix-keyring     -- fix Arch Linux keyring if has a corrupt signature"
	@echo "check                -- check for git leaks"
	@echo "install-clipmenu     -- clones clipmenu repo (Xorg only)"
	@echo "install-invidious    -- clones invidious repo"
	@echo "list                 -- list make commands (Default)"
	@echo "setup-flathub        -- adds flathub repo to flatpak"
	@echo "setup-termux         -- install termux packages"
	@echo "stow                 -- run neostow"
	@echo "submodule            -- clones submodules"

stow:
	./.local/bin/config-distro
	git clone https://codeberg.org/aocoronel/neostow-rs || echo "Already cloned"
	cd neostow-rs && cargo build
	./neostow-rs/target/debug/neostow-rs -V -o

check:
	gitleaks git

arch-fix-keyring:
	sudo rm -R /etc/pacman.d/gnupg/
	sudo rm -R /root/.gnupg/
	gpg --refresh-keys
	sudo pacman-key --init && sudo pacman-key --populate archlinux

install-invidious:
	git clone https://github.com/iv-org/invidious.git "$HOME/invidious"
	echo "Manual changes required. See https://docs.invidious.io/installation/#docker-compose-method-production for details"

setup-termux:
	ln -s ~/dotfiles/.termux ~/
	pkg install zsh fzf direnv python golang ranger yazi zoxide git rclone rsync busybox openssh termux-api cmus tmux curl lazygit git ffmpeg just bat eza git-crypt mandoc mpv ripgrep yt-dlp stow neovim gnupg taskwarrior lynx imagemagick timewarrior wget jq fd  moreutils newsboat restic unzip wget pass helix libllvm nodejs

install-clipmenu:
	git clone https://github.com/cdown/clipmenu.git "$HOME/dev/3p/clipmenu"

setup-flathub:
	flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

clone-elegantvagrant:
	git clone git@codeberg.org:aocoronel/elegantvagrant || echo "Already cloned."

clone-nvim:
	git clone git@github.com:aocoronel/nvim .config/nvim || echo "Already cloned."

submodule: clone-elegantvagrant clone-nvim
