#!/usr/bin/env bash
set -e
source ./common.sh
export LOGPREFIX="[${BASH_SOURCE[0]}]"

echo "Installing files into rootfs/"
install -m 755 ./common.sh rootfs/root/
install -m 644 files/sources.list rootfs/etc/apt/
install -m 644 files/raspi.list rootfs/etc/apt/sources.list.d/
install -m 644 files/vscode.list rootfs/etc/apt/sources.list.d/
#install -vm 755 files/initramfs-5.10.11-v8-btrfs-iscsi+.gz rootfs/boot/
install -m 755 r00-installapps1.sh rootfs/root/
install -m 755 r10-configrescue.sh rootfs/root/
install -m 755 r20-installapps2.sh rootfs/root/
install files/cmdline.txt rootfs/boot/
install files/config.txt rootfs/boot/
install -m 644 files/fstab-rescue rootfs/etc/fstab
install -d rootfs/etc/systemd/system/getty@tty1.service.d
install -m 644 files/noclear.conf rootfs/etc/systemd/system/getty@tty1.service.d/noclear.conf
install -m 644 files/*5.11* rootfs/root/
install -m 644 files/deno*.deb rootfs/root/
install -m 644 files/70debconf rootfs/etc/apt/apt.conf.d/
