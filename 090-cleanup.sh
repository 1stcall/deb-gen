#!/usr/bin/env bash
set -e
source ./common.sh
LOGPREFIX="[${BASH_SOURCE[0]}]"

filename=$(basename -- "${0}")
extension="${filename##*.}"
filename="${filename%.*}"
logname="${filename}.log"
outname="${filename}.out"

echo "Cleaning up"

while read -r mountpoint; do sudo umount -v $mountpoint; done < <(awk '$2 ~ "^'$(pwd)'" { print $2 }' /proc/mounts)
kpartx -dv image.img || true
rm -r {bootfs/,rescuefs/,rootfs/,rescuemnt/,rootmnt/,bootmnt/}