# My Arch Linux setup

Guiding principles:
- Practicality
- Minimalism
- Aesthetics

## Installation

Base packages to install:
```
# pacstrap /mnt base linux linux-firmware base-devel intel-ucode broadcom-wl neovim git
```

## Reboot into the new installation

Clone this repository and run the set-up-system script.

Change the default shell to zsh.
```
$ chsh -s /usr/bin/zsh
```

Reboot the system. Everything should now work fine.
