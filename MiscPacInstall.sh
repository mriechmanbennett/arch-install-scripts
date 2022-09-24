#!/usr/bin/env bash
pacman -Syu
pacman -S linux linux-headers sddm plasma-meta plasma-wayland-session sddm pipewire pipewire-pulse pipewire-alsa p7zip os-prober nmap nftables firewalld bluez bluez-utils aircrack-ng wireshark-qt android-tools android-udev make cups bitwarden dosfstools exfat-utils ettercap firefox flatpak gparted iio-sensor-proxy kde-applications-meta lvm2 make metasploit network-manager network-manager-applet reflector ruby python3 signal-desktop steam signify veracrypt vim wget qt5-base wpa-supplicant xdg-utils xdg-user-dirs wayland yt-dlp git libreoffice-fresh

# Build and install yay
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER ./yay-git
cd yay-git
makepkg -si

# Install AUR packages
yay -S ttf-liberation
yay -S ttf-ms-win10-auto
yay -S protonvpn
