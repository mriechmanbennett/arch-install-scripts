#!/usr/bin/env bash

# Static variables
CRYPTVOL="cryptlvm"
VGNAME="volgroup"
USERHOSTNAME="framework"
# Default partition sizes
echo "Please type the name of the boot partition"
read BOOTNAME
echo "Please type the name of the system encrypted partition"
read SYSNAME

echo -e "127.0.0.1\tlocalhost\n::1\tlocalhost\n127.0.0.1\t$USERHOSTNAME.localdomain\t$USERHOSTNAME" >> /etc/hosts

#Grub Install
BOOTUUID=$(blkid | grep $SYSNAME | sed 's/" TYPE=.*//g' | sed 's/.*UUID="//g')
sed -i "s/GRUB_CMDLINE_LINUX=../GRUB_CMDLINE_LINUX=QUOTEcryptdevice=$BOOTUUID:$CRYPTVOL root=\/dev\/$VGNAME\/root mem_sleep_default=deep i915.enable_psr=QUOTE/g" /etc/default/grub
sed -i 's/QUOTE/"/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Enable some services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable fstrim.timer
