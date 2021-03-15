#!/usr/bin/env bash
set -e
source ./common.sh
LOGPREFIX="[${BASH_SOURCE[0]}]"

log "Making rescuefs/"
log "${TARGET_HOSTNAME}" > "rootfs/etc/hostname"
log "127.0.1.1		${TARGET_HOSTNAME}  ${TARGET_SHORTNAME}" >> "rootfs/etc/hosts"

ln -sf /dev/null "rootfs/etc/systemd/network/99-default.link"

sudo cp -ar --reflink rootfs/ rescuefs/
