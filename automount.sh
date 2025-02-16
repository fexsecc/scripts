#!/bin/sh

# A bash script to mount drives. Works with normal partitions as well as LUKS.

pgrep -x dmenu && exit

mountable=$(lsblk -lp | grep -E "part  $" | awk '{print $1, "(" $4 ")" }')
[[ "$mountable" = "" ]] && exit 1
chosen=$(echo "$mountable" | dmenu -i -p "Mount which drive?" | awk '{print $1}')

yn=$(echo -e "yes\nno" | dmenu -i -p "Encrypted? (y/n)")

if [ $yn == "yes" ]; then
  mapper_name=$(echo -e "backup\nencrypted\nsomething else..." | dmenu -i -p "Which mapper name do you give it?")
  echo $mapper_name
  if [ "$mapper_name" == "something else..." ]; then
    echo -n "Enter your custom mapper name: "
    read -r mapper_name
  fi
  sudo cryptsetup open "$chosen" "$mapper_name"
fi

dir=$(find /mnt -maxdepth 3 2>/dev/null | dmenu -i -p "Where do you mount it?")

if [ "$yn" == "yes" ]; then
  sudo mount "/dev/mapper/$mapper_name" "$dir"
else
  sudo mount "$chosen" "$dir"
fi

echo "Hold on while we change directories permissions (DONT press CTRL+C)"
sudo chown -R "$USER:$USER" "$dir"
