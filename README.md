# ArchInstallScripts
A collection of scripts to streamline my setup of new Arch Linux installs
The setup I use is LVM on LUKS, so archsetup.sh will create your system that way.
There are default values at the top of archsetup.sh that you can modify if you want.
paclist.txt has the list of packages that will be installed during archsetup.sh
Verify that you want those packages before running the setup script.

WARNING - These scripts are untested and unfinished
I've just been writing them stream of consciousness and have not verified that they won't build you a broken system.

Order of operations:
Run mirrorset.sh first
Partition disk manually with one 300 MiB for the boot partition and the rest as a single partition to hold the encrypted lvm setup
archsetup.sh will take the boot partition and the LUKS partition device names you want, and set things up from there
Run archsetup.sh and answer the questions it asks you
??? haven't finished archsetup.sh yet
