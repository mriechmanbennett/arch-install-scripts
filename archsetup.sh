#!/usr/bin/env bash

# Static variables
CRYPTVOL="cryptlvm"
VGNAME="vg1"

# Default partition sizes
ROOTSIZE="100G"
SWAPSIZE="32G"
# Home will always take all left over space
echo "Please type the name of the boot partition"
read BOOTNAME
echo "Please type the name of the system encrypted partition"
read SYSNAME
echo "(i)ntel or (a)md?"
read PROCESSOR
if $PROCESSOR=="i"
then
	$PROCPAC="intel-ucode"
else
	$PROCPAC="amd-ucode"
fi
echo "What should the hostname be?"
read USERHOSTNAME


# Set up encrypted volume
cryptsetup luksFormat $SYSNAME
cryptsetup open $SYSNAME $CRYPTVOL
pvcreate /dev/mapper/$CRYPTVOL

# Create volume group
vgcreate $VGNAME /dev/mapper$CRYPTVOL
lvcreate -L $ROOTSIZE $VGNAME -n root
lvcreate -L $SWAPSIZE $VGNAME -n swap
lvcreate -l 100%FREE $VGNAME -n home

# Format partitions
mkfs.fat -F32 $BOOTNAME
mkfs.ext4 /dev/$VGNAME/root
mkfs.ext4 /dev/$VGNAME/home
mkswap /dev/$VGNAME/swap

# Mount new filesystem
mount /dev/$VGNAME/root /mnt
mkdir /mnt/home
mount /dev/$VGNAME/home /mnt/home
mkdir /mnt/boot
mount $BOOTNAME /mnt/boot
swapon /dev/vg1/swap

# Pacstrap
pacstrap /mnt base linux linux-firmware vim git $PROCPAC lvm2
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

# Set default timezone
# probably change this if you aren't central time US lol
ln -sf /user/share/zoneinfo/US/Central /etc/localtime
hwclock --systohc

# locale-gen
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo $USERHOSTNAME >> /etc/hostname
echo -e "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.0.1\t$USERHOSTNAME.localdomain\t$USERHOSTNAME" >> /etc/hosts

# Set root password
echo "Enter your root password"
passwd

# Install packages
pacman -S --needed - <paclist.txt

# Setup mkinitcpio
grep -F "HOOKS=(base udev autodetect modconf block filesystems" /etc/mkinitcpio.conf
