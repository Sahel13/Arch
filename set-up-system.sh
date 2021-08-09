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
xf86-video-intel
# XMonad
xmonad
xmonad-contrib
xmobar
# Autostart applications
feh
picom
polkit-gnome
dunst
xfce4-power-manager
unclutter
# Others
dmenu
alacritty
# Fonts
ttf-font-awesome
ttf-ubuntu-font-family
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
zsh
zsh-completions
# Neovim plugins
python-pynvim
xclip
# Python
python
python-pip
python-pipenv
# Save git password
gnome-keyring
libsecret
# Task manager
htop
# Screenshot
flameshot
# CPU
cpupower
thermald
# Firewall
nftables
# Others
tree # For filesystem exploration
rsync # Copy files fast
wget
pacman-contrib # To run package cache cleaning service
reflector # Get faster mirrors
tmux # Terminal multiplexer
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

sudo systemctl enable --now cpupower.service
sudo systemctl enable --now thermald.service
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
alsa-utils
bluez
bluez-utils
pulseaudio
pulseaudio-alsa
pulseaudio-bluetooth
# GUIs 
pavucontrol
blueman
)

count=0
for name in "${list[@]}" ; do
	count=$[count+1]
	tput setaf 3;echo "Installing package nr.  "$count " " $name;tput sgr0;
	func_install $name
done

sudo systemctl enable --now bluetooth.service

###############################################################################

func_category "Applications"

list=(
firefox
vlc
discord
signal-desktop
telegram-desktop
anki
remmina
freerdp
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
# Latex
texlive-core
texlive-latexextra
texlive-science
biber
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
git clone --bare https://github.com/Sahel13/dotfiles.git ~/.dotfiles
rm ~/.bashrc
config="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
$config checkout
$config config --local status.showUntrackedFiles no

# Systemd services
sudo rsync -a systemd/ /etc/systemd/system/
sudo systemctl enable --now fix-auto-wakeup.service
sudo systemctl enable --now root-resume.service

# Pacman hooks
sudo cp -r pacman /etc/pacman.d/hooks

# Keep SSD in good health
sudo systemctl enable --now fstrim.timer # SSD

# Pam (for gnome-keyring autologin)
sudo cp login /etc/pam.d/

# Touchpad preferences
sudo cp 30-touchpad.conf /etc/X11/xorg.conf.d/

# Refresh font cache
fc-cache -fv

# Zsh configuration
mkdir ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
