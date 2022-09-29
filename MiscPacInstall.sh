#!/usr/bin/env bash
pacman -Syu
pacman -S --needed - <paclist.txt

# Build and install yay
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git
cd yay-git
makepkg -si

# Install AUR packages
yay -S ttf-liberation
yay -S ttf-ms-win10-auto
yay -S protonvpn
