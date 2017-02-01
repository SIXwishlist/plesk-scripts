#!/bin/bash

# User-Data Script for DigitalOcean, etc

# https://docs.plesk.com/release-notes/onyx/hardware-requirements/
mem=`free -t -g | grep Total | awk '{ print $2 }'`
if [ "0" = $mem ]; then
  fallocate -l 4G /swapfile
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile       none    swap    sw 0 0' >> /etc/fstab
fi
  
# https://docs.plesk.com/en-US/onyx/deployment-guide/plesk-installation-and-upgrade-on-single-server/
sh <(curl https://installer.plesk.com/one-click-installer || wget -O – https://installer.plesk.com/one-click-installer)
  
# Generate new password
passwd=`cat /dev/urandom | tr -dc 'a-zA-Z0-9-_@#$%^&*()_+{}|:<>?=' | fold -w 12 | head -n 1`
 
# https://support.plesk.com/hc/en-us/articles/213381869
/usr/local/psa/bin/init_conf -u -passwd "$passwd"
 
# PASSWORD
echo "New administrator's password: " $passwd
