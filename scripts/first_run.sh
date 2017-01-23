#!/bin/bash

# https://bbs.nextthing.co/t/a-few-things-that-a-new-chip-pocketchip-owner-should-do-know-and-try/13803

# must run as ROOT
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Update
if (whiptail --title "Update" --yesno "It's recommended to perform a system update,\ndo you want to do this now?\n(internet connection required)" 8 40) then
  apt update
  apt upgrade -y
  apt-get autoremove --purge -y
fi

# hostname
CURRENTHOST=`hostname`
NEWHOST=$(whiptail --title "Hostname" --inputbox "\nEnter new hostname:" 9 40 $CURRENTHOST 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
  sed -i "s/$CURRENTHOST/$NEWHOST/g" "/etc/hosts"
  sed -i "s/$CURRENTHOST/$NEWHOST/g" "/etc/hostname"
  hostname $NEWHOST
  echo "The new hostname is '$NEWHOST'"
fi

# change 1000 username and set new password
CURRENTUSER=`cat /etc/passwd | grep 1000 | cut -d: -f1`
NEWUSER=$(whiptail --title "User" --inputbox "\nEnter new username for UID 1000:" 9 40 $CURRENTUSER 3>&1 1>&2 2>&3)
exitstatus=$?
if [ $exitstatus = 0 ]; then
  usermod -l "$NEWUSER" -d "/home/$NEWUSER" -m "$CURRENTUSER"
fi

clear
echo "Enter password for the user '$NEWUSER':"
passwd "$NEWUSER"
CURRENTUSER=$NEWUSER

# disable root login, other user can still use sudo
if (whiptail --title "Root Password" --yesno "Remove root password?" 8 40) then
  passwd -dl root
fi

# Locale amd Timezone
if (whiptail --title "Locale amd Timezone" --yesno "Install and configure Locales amd Timezones?" 8 40) then
  apt install -y locales
  dpkg-reconfigure locales
  dpkg-reconfigure tzdata
fi

# Swappiness
if (whiptail --title "Swappiness" --yesno "Protect NAND by reducing swappiness to 10?" 8 40) then
  if [ $(cat /etc/sysctl.conf | grep vm.swappiness | wc -l) -eq 0 ]; then

cat <<EOF >> /etc/sysctl.conf
#
# protect NAND by reducing swappiness to 10
vm.swappiness = 10
EOF

  fi
  echo 10 > /proc/sys/vm/swappiness
fi

# Enable ll command
if (whiptail --title "Enable ll command" --yesno "Enable ll command?" 8 40) then

  # ll for root
  sed -i "s/# export LS_OPTIONS='--color=auto'/export LS_OPTIONS='--color=auto -haX --group-directories-first'/g" "/root/.bashrc"
  sed -i "s/# alias ll/alias ll/g" "/root/.bashrc"

  # ll for user 1000
  sed -i "s/# export LS_OPTIONS='--color=auto'/export LS_OPTIONS='--color=auto -haX --group-directories-first'/g" "/home/$CURRENTUSER/.bashrc"
  sed -i "s/# alias ll/alias ll/g" "/home/$CURRENTUSER/.bashrc"

fi
