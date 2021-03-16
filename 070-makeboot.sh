#!/usr/bin/env bash
set -e
source ./common.sh
LOGPREFIX="[${BASH_SOURCE[0]}]"

log "Making bootfs/"
rm -r bootfs/ > /dev/null 2>&1 || true 
mkdir bootfs
cp -ar --reflink rescuefs/boot/* bootfs/
rm -r rescuefs/boot/*
cp -ar --reflink rootfs/boot/* bootfs/
rm -r rootfs/boot/*
log "Done making bootfs/"