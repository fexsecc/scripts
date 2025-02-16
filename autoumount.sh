#!/bin/sh

# A bash script to unmount drives. It by default excludes /, /home and /boot for obvious reasons.

pgrep -x dmenu && exit

exclusionregex="\(/boot\|home\|/\)$"
drives=$(lsblk -lp | grep "t /" | grep -v "$exclusionregex" | awk '{print $1, "(" $4 ")", "on", $7}')
[[ "$drives" == "" ]] && exit
chosen=$(echo "$drives" | dmenu -i -p "Unmount which drive?" | awk '{print $4" "$1}')
[[ "$chosen" == "" ]] && exit

umount_path=$(echo "$chosen" | awk '{print $1}')
disk_path=$(echo "$chosen" | awk '{print $2}')

sudo umount "$umount_path"
if [[ $disk_path == *"mapper"* ]]; then
  sudo cryptsetup close "$disk_path"
fi
