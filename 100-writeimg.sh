#!/usr/bin/env bash
set -e
source ./common.sh
LOGPREFIX="[${BASH_SOURCE[0]}]"

filename=$(basename -- "${0}")
extension="${filename##*.}"
filename="${filename%.*}"
logname="${filename}.log"
outname="${filename}.out"

echo "Writing image to /dev/sdb in 10 seconds"
sleep 10
sudo dd if=image.img of=/dev/sdb bs=128M conv=sync status=progress
sudo sync
sudo eject /dev/sdb

