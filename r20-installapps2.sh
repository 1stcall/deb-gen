#!/usr/bin/env bash
set -e
LOGPREFIX="[${BASH_SOURCE[0]}]"
cd /root/
. ./common.sh
echo "Adding resizebtrfs_once to startup"
update-rc.d resizebtrfs_once defaults
echo "Installing desktop apps"
apt install -y mate-* lightdm libreoffice code gparted rc-gui firefox-esr
echo "Setting fs.inotify.max_user_watches=524288"
echo fs.inotify.max_user_watches=524288 >> /etc/sysctl.conf
