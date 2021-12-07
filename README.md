# My Arch Linux setup

Guiding principles in the order of priority:
- Practicality
- Minimalism
- Aesthetics

## Base system installation

Create partitions with the labels "Arch Linux" for root and "Swap" for swap. Install the base packages:
```
# pacstrap /mnt base linux linux-firmware base-devel intel-ucode broadcom-wl neovim git
```

Clone this repository after chrooting into the system and run `installer.sh`. The steps left are:
1. Configure and regenerate the initramfs for [hibernation support](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Configure_the_initramfs).
2. Add a superuser password.
3. Create a user with sudo privileges.

Exit from the live installer and reboot.

## Setting up the system

Run the set-up-system script (add or remove packages as necessary).

Change the default shell to zsh.
```
$ chsh -s /usr/bin/zsh
```

Reboot.
