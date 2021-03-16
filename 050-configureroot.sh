#!/bin/env bash
LOGPREFIX="[${BASH_SOURCE[0]}]"
export TARGET_HOSTNAME=rpi4b-1.1stcall.uk
export TARGET_SHORTNAME=rpi4b-1
set -e
source ./common.sh

log "Configuring rootfs"
log "${TARGET_HOSTNAME}" > "rootfs/etc/hostname"
log "127.0.1.1		${TARGET_HOSTNAME}  ${TARGET_SHORTNAME}" >> "rootfs/etc/hosts"

ln -sf /dev/null "rootfs/etc/systemd/network/99-default.link"

install -vm 644 files/fstab-root rootfs/etc/fstab
install -m 755 files/resizebtrfs_once rootfs/etc/init.d/