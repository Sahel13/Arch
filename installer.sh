#!/bin/bash

# Set the time zone
ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
hwclock --systohc

# Localization
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Network configuration
echo "macarch" > /etc/hostname
echo "127.0.0.1 localhost" > /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 macarch.localdomain macarch" >> /etc/hosts

# Boot loader
bootctl --path=/boot install
echo "default  arch.conf" > /boot/loader/loader.conf
cp arch.conf /boot/loader/entries/

# Essential packages
pacman -S --noconfirm networkmanager tlp
systemctl enable NetworkManager tlp

