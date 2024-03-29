#!/bin/bash

# From https://github.com/arcolinuxd/arco-xmonad/blob/master/200-software-arch-linux.sh

func_install() {
	if pacman -Qi $1 &> /dev/null; then
		tput setaf 2
		echo "###############################################################################"
		echo "################## The package "$1" is already installed"
		echo "###############################################################################"
		echo
		tput sgr0
	else
		tput setaf 3
		echo "###############################################################################"
		echo "##################  Installing package "  $1
		echo "###############################################################################"
		echo
		tput sgr0
		sudo pacman -S --noconfirm --needed $1
	fi
}

func_category() {
	tput setaf 5;
	echo "################################################################"
	echo "Installing software for category " $1
	echo "################################################################"
	echo;tput sgr0
}

###############################################################################

func_category "Desktop Environment"

list=(
# Xorg
xorg
xorg-xinit
# Video driver
mesa
xf86-video-amdgpu
# XMonad
xmonad
xmonad-contrib
xmobar
trayer
# Autostart applications
feh
picom
xcape
dunst
unclutter
# Others
dmenu
alacritty
# Fonts
ttf-font-awesome
ttf-mononoki-nerd
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

###############################################################################

func_category "Utilities"

list=(
# zsh
zsh
zsh-completions
# Neovim plugins
python-pynvim
xclip
powerline-fonts
# Python
python
python-pip
# CPU
# cpupower
# thermald
# Vim fuzzy file finding
fzy
ripgrep
# Others
htop
openssh
wget
rsync
# reflector
flameshot # Screenshot tool
nftables # Firewall
pacman-contrib # To run package cache cleaning service
tmux # Terminal multiplexer
# nomacs # Image viewer
slock # Screen locker
# redshift # Night mode
network-manager-applet
nm-connection-editor # To configure University wifi
rclone # To sync files with online drives.
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

# sudo systemctl enable --now cpupower.service
# sudo systemctl enable --now thermald.service
sudo systemctl enable --now nftables.service

###############################################################################

func_category "File Manager"

list=(
xdg-user-dirs
xdg-utils
ranger
thunar
gvfs
gvfs-mtp
tumbler
file-roller
thunar-archive-plugin
thunar-volman
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

# Create user directories
xdg-user-dirs-update

###############################################################################

func_category "Sound and Bluetooth"

list=(
# alsa-utils
# bluez
# bluez-utils
# pulseaudio
# pulseaudio-alsa
# pulseaudio-bluetooth
# # GUIs 
# pavucontrol
# blueman
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

# sudo systemctl enable --now bluetooth.service

###############################################################################

func_category "Applications"

list=(
firefox
signal-desktop
# obsidian
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

###############################################################################

func_category "Productivity software"

list=(
# Pdf viewer
zathura
zathura-pdf-poppler
zathura-djvu
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

# Make zathura the default pdf viewer
xdg-mime default org.pwmt.zathura.desktop application/pdf

###############################################################################

tput setaf 11;
echo "################################################################"
echo "Software has been installed"
echo "################################################################"

# Get the dofiles
git clone --bare git@github.com:Sahel13/dotfiles.git ~/.dotfiles
rm ~/.bashrc
config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
$config checkout
$config config --local status.showUntrackedFiles no

# Copy all system files
# sudo rsync -a etc/ /etc/

# Start custom systemd services
# sudo systemctl enable --now slock@sahel.service

# Keep SSD in good health
sudo systemctl enable --now fstrim.timer # SSD

# Zsh configuration
mkdir ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
