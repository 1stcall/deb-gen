#!/usr/bin/env bash
set -e
source ./common.sh
LOGPREFIX="[${BASH_SOURCE[0]}]"

if ! [[ -d debootstrap/ ]]; then
    echo "Debootstraping system to debootstrap/"

    debootstrap --arch arm64 --cache-dir=/home/carl/buildsys/apt-cache --components main,contrib,non-free,rpi --include \
gnupg2,locales,ca-certificates,sudo,nano,systemd-container,debootstrap,bash-completion,pciutils,ntfs-3g,\
command-not-found,btrfs-progs,netbase,rsync,git,ssh,less,fbset,sudo,psmisc,strace,ed,ncdu,ethtool,rng-tools,ssh-import-id,\
crda,console-setup,keyboard-configuration,debconf-utils,parted,unzip,systemd-container,libmtp-runtime,rsync,htop,man-db,\
policykit-1,build-essential,manpages-dev,python,gdb,pkg-config,python-rpi.gpio,v4l-utils,avahi-daemon,lua5.1,luajit,\
hardlink,curl,fake-hwclock,nfs-common,usbutils,apt-listchanges,usb-modeswitch,dosfstools,cifs-utils,\
net-tools,dhcpcd5,wpasupplicant,wireless-tools,firmware-atheros,firmware-brcm80211,firmware-libertas,\
firmware-misc-nonfree,firmware-realtek,kpartx,busybox-static,tmux,targetcli-fb,open-iscsi,neofetch \
    buster ./debootstrap
fi

echo "Generating rootfs/ from  debootstrap/"
cp -ar --reflink debootstrap/ rootfs/
