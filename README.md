# Easy Arch Install
A collection of scripts to streamline my setup of new Arch Linux installs

WARNING - These scripts are untested and unfinished and full of errors, use at your own risk

Order of operations:
Run mirrorset.sh first
Partition disk manually with one 300 MiB for the boot partition and the rest as a single partition to hold the encrypted lvm setup
archsetup.sh will take the boot partition and the LUKS partition device names you want, and set things up from there
Run archsetup.sh and answer the questions it asks you
??? haven't finished archsetup.sh yet
