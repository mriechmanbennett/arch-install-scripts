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
echo "What should the user account name be?"
read USERACCOUNTNAME

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
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
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
sed -i 's/HOOKS=(base udev autodetect modconf block filesystems/HOOKS=(base udev autodetect modconf block encrypt lvm2 filesystems keymap/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

#Grub Install
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
BOOTUUID=$(blkid | grep $SYSNAME | sed 's/" TYPE=.*//g' | sed 's/.*UUID="//g')
sed -i "s/GRUB_CMDLINE_LINUX=../GRUB_CMDLINE_LINUX=QUOTEcryptdevice=$BOOTUUID:$CRYPTVOL root=/dev/$VGNAME/root mem_sleep_default=deep i915.enable_psr=QUOTE/g" /etc/default/grub
sed -i 's/QUOTE/"/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable fstrim.timer
