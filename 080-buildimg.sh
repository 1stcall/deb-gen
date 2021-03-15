#!/usr/bin/env bash
set -e
source ./common.sh
LOGPREFIX="[${BASH_SOURCE[0]}]"

echo "Building image.img"

rm -v image.img || true
truncate image.img --size=10000000000

echo "Adding partition table"
parted image.img mklabel msdos

echo "Writing partition information from sda.sfdisk"
sfdisk image.img < sda.sfdisk
PTUUID=$( /sbin/blkid ./image.img | awk '{ print $2 }' | sed 's/PTUUID="//g' | sed 's/"//g' )
LOOPDEV=$( kpartx -lv ./image.img | head -n 1 | awk '{ print $1 }' | cut -c1-5 )

kernel=$(basename $(ls ./bootfs/vmlinuz*))
sed -i "s/\[ROOTPART\]/PARTUUID=${PTUUID}-03/g" ./bootfs/cmdline.txt
sed -i "s/\[FSTYPE\]/btrfs/g" ./bootfs/cmdline.txt
sed -i "s/\[ROOTFLAGS\]/subvol=@root/g" ./bootfs/cmdline.txt
sed -i "s/\#kernel=\[KERNEL\]/kernel=${kernel}/g" ./bootfs/config.txt

kpartx -av image.img
echo "Making boot filesystems PTUUID=${PTUUID}  LOOPDEV=${LOOPDEV}"
#mkfs.fat -v -n boot /dev/mapper/${LOOPDEV}p1
mkfs.fat -F32 -v -n boot /dev/mapper/${LOOPDEV}p1
echo "Making rescue filesystems"
mkfs.ext4 -L rescue /dev/mapper/${LOOPDEV}p2
echo "Making root filesystems"
mkfs.btrfs -fL root /dev/mapper/${LOOPDEV}p3
kpartx -uv image.img
echo "Setting up mount points"
rm -r {bootmnt/,rootmnt/,rescuemnt/} 2> /dev/null || true
mkdir {bootmnt/,rootmnt/,rescuemnt/}
echo "Mounting partitions /dev/mapper/${LOOPDEV}p1 bootmnt/"
mount /dev/mapper/${LOOPDEV}p1 bootmnt/
echo "Mounting partitions /dev/mapper/${LOOPDEV}p2 rescuemntmnt/"
mount /dev/mapper/${LOOPDEV}p2 rescuemnt/
echo "Mounting partitions /dev/mapper/${LOOPDEV}p3 rootmnt/"
mount /dev/mapper/${LOOPDEV}p3 rootmnt/
echo "Creating subvolume @root"
btrfs subvolume create rootmnt/@root
echo "Copying bootfs"
cp -a bootfs/* bootmnt/
echo "Copying rootfs"
cp -a rootfs/* rootmnt/@root/
echo "Copying rescuefs"
cp -a rescuefs/* rescuemnt/
echo "Unmounting filesystems"
umount -v {bootmnt/,rootmnt/,rescuemnt/}
kpartx -dv image.img
echo "Done."
