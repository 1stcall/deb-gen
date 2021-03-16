#!/usr/bin/env bash
LOGPREFIX="[${BASH_SOURCE[0]}]"
set -e
cd /root/

. ./common.sh
echo "Adding arch armf"
dpkg --add-architecture armhf
echo "Adding any missing keys to apt"
apt update 2>&1 | sed -ne 's?^.*NO_PUBKEY ??p' | sort -u | xargs -r -- sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 2>/dev/null
echo "Updating package list"
apt update
echo "Performing upgrade"
apt full-upgrade -y
apt autoremove -y
echo "Installing kernel, bootloader, firmware & Deno"
dpkg -i *.deb
echo "Installing rpi specific apps"
apt install -y raspberrypi-bootloader libraspberrypi-bin libraspberrypi0 raspi-config libraspberrypi-dev \
    libraspberrypi-doc libfreetype6-dev raspberrypi-sys-mods pi-bluetooth rpi-update rpi-eeprom raspinfo \
    libpam-chksshpwd vl805fw raspberrypi-net-mods
