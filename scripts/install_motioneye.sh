#!/bin/bash

# https://bbs.nextthing.co/t/build-a-full-featured-security-cam-for-cheap/12573

# must run as ROOT
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

if (whiptail --title "MotionEye" --yesno "Install MotionEye?" 15 46) then

  # dependencies
  apt install -y python-pip python-dev curl libssl-dev libcurl4-openssl-dev libjpeg-dev libx264-142 libavcodec56 libavformat56 libmysqlclient18 libswscale3 libpq5 v4l-utils uvcdynctrl ffmpeg

  # motion
  apt-get install -y motion
  sed -i "s/v4l2_palette 17/v4l2_palette 15/g" "/etc/motion/motion.conf"
  systemctl daemon-reload
  systemctl enable motion
  systemctl start motion 

  # motioneye
  pip install motioneye
  mkdir -p /etc/motioneye
  cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
  mkdir -p /var/lib/motioneye
  cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service

  # Change port from 8765
  NEWPORT=$(whiptail --title "MotionEye port" --inputbox "\nEnter port number" 15 46 "8765" 3>&1 1>&2 2>&3)
  exitstatus=$?
  if [ $exitstatus = 0 ]; then
    sed -i 's/port .*/port $NEWPORT/g' /etc/motioneye/motioneye.conf
  fi
  
  systemctl daemon-reload
  systemctl enable motioneye
  systemctl start motioneye

fi
