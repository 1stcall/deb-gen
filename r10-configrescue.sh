#!/usr/bin/env bash

LOGPREFIX="[${BASH_SOURCE[0]}]"
set -e
cd /root/
. ./common.sh
#!/usr/bin/env bash

echo "Configuring 1st user"
FIRST_USER_NAME=carl
adduser --disabled-password --gecos "" carl
echo $FIRST_USER_NAME:letmein123 | chpasswd
echo "root:root" | chpasswd
passwd --expire carl

for GRP in input spi i2c gpio; do
	groupadd -f -r "${GRP}"
done
for GRP in adm dialout cdrom audio users sudo video games plugdev input gpio spi i2c netdev; do
  adduser $FIRST_USER_NAME ${GRP}
done

echo "Configuring locales"
LOCALE_DEFAULT="${LOCALE_DEFAULT:-en_GB.UTF-8}"
sudo debconf-set-selections < <(echo "locales locales/locales_to_be_generated multiselect ${LOCALE_DEFAULT} UTF-8 locales locales/default_environment_locale select ${LOCALE_DEFAULT}")
#systemctl enable resizebtrfs_once
systemctl enable systemd-resolved.service
