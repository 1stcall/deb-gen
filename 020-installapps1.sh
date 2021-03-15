#!/usr/bin/env bash
set -e
source ./common.sh
LOGPREFIX="[${BASH_SOURCE[0]}]"

/usr/bin/systemd-nspawn --directory ./rootfs /root/r00-installapps1.sh 2>&1