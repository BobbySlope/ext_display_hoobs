#!/bin/bash

# DO NOT USE THIS SCRIPT - ITS IN TESTING STATE AND MAY CORRUPT YOUR HOOBS DEVICE


# HOW TO RUN THE SCRIPT

# sudo wget -q -O - https://raw.githubusercontent.com/BobbySlope/ext_display_hoobs/main/install_script.sh | sudo bash -



##################################################################################################
# ext_display_hoobs.                                                                             #
# Copyright (C) 2022 HOOBS                                                                       #
#                                                                                                #
# This program is free software: you can redistribute it and/or modify                           #
# it under the terms of the GNU General Public License as published by                           #
# the Free Software Foundation, either version 3 of the License, or                              #
# (at your option) any later version.                                                            #
#                                                                                                #
# This program is distributed in the hope that it will be useful,                                #
# but WITHOUT ANY WARRANTY; without even the implied warranty of                                 #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                                  #
# GNU General Public License for more details.                                                   #
#                                                                                                #
# You should have received a copy of the GNU General Public License                              #
# along with this program.  If not, see <http://www.gnu.org/licenses/>.                          #
##################################################################################################
# Author: Bobby Slope     

echo "Updating apt-get...."
sudo apt-get update --yes
 
echo "install openbox and firefox-esr...."
DEBIAN_FRONTEND=noninteractive sudo apt-get install --no-install-recommends xserver-xorg x11-xserver-utils xinit xserver-xorg-video-fbdev openbox -y
sudo apt-get install firefox-esr -y

echo "set openbox to start firefox with url...."
cat > /etc/xdg/openbox/autostart  <<EOL
# Disable any form of screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms
# Allow quitting the X server with CTRL-ATL-Backspace
setxkbmap -option terminate:ctrl_alt_bksp
#start firefox with url
firefox-esr --kiosk http://localhost
EOL

echo "enable autostart openbox after login...."
cat > .bash_profile <<EOL
startx 
EOL

echo "enable autologin for user hoobs to CLI...."
sudo mkdir /lib/systemd/system/getty@tty1.service.d/
cat > /lib/systemd/system/getty@tty1.service.d/20-autologin.conf <<EOL
#Autologin to Console
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin hoobs --noclear %I $TERM
EOL

echo "----------------------------------------------------------------"
echo "Setup successful"
echo "----------------------------------------------------------------"
echo "rebooting in 10secs"
echo "----------------------------------------------------------------"
sleep 10
sudo reboot




