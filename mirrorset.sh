#!/usr/bin/env bash
timedatectl set-ntp true
pacman -Syy reflector
reflector -c "United States" -a 6 --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syyy
