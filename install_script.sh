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


sudo apt-get update --yes
# echo "----------------------------------------------------------------"
# echo "This script will Setup the external Touchdisplay Widget for HOOBS"
# echo "----------------------------------------------------------------"
#echo " "
#echo "Setup Touchscreen...."
#sudo rm -rf LCD-show
#git clone https://github.com/goodtft/LCD-show.git
#sudo chmod -R 755 LCD-show
#cd LCD-show/
#sudo ./LCD35-show
#echo "----------------------------------------------------------------"
#echo "Touchscreen Installed"
#echo "----------------------------------------------------------------"
echo " "
echo "Setup Autologin to CLI...."
sudo mkdir /lib/systemd/system/getty@tty1.service.d/
cat > /lib/systemd/system/getty@tty1.service.d/20-autologin.conf <<EOL
#Autologin to Console
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin hoobs --noclear %I $TERM
EOL
echo "----------------------------------------------------------------"
echo "Autologin CLI Installed"
echo "----------------------------------------------------------------"
echo " "
echo "install Fullscreen Dashboard...."
sudo apt-get install --no-install-recommends xserver-xorg x11-xserver-utils xinit xserver-xorg-video-fbdev openbox -y
sudo apt-get install --no-install-recommends chromium -y
sudo apt-get install --no-install-recommends libgl1-mesa-dri -y
#sudo apt-get install lightdm -y

#echo "set screen...."
#sudo rm -rf usr/share/X11/xorg.conf.d/99-fbturbo.conf
#cat > /usr/share/X11/xorg.conf.d/99-fbturbo.conf <<EOL
#Section "Device"
#        Identifier      "Allwinner A10/A13/A20 FBDEV"
#        Driver          "fbturbo"
#        Option          "fbdev" "/dev/fb1"
#
#        Option          "SwapbuffersWait" "true"
#EndSection
#EOL

#echo "set wrapper...."
#sudo rm -rf /etc/X11/Xwrapper.config
#cat > /etc/X11/Xwrapper.config <<EOL
#allowed_users=anybody
#needs_root_rights=no
#EOL


cat > /etc/xdg/openbox/autostart  <<EOL
# Disable any form of screen saver / screen blanking / power management
xset s off
xset s noblank
xset -dpms

# Allow quitting the X server with CTRL-ATL-Backspace
setxkbmap -option terminate:ctrl_alt_bksp
# Deletes Chromium cache on startup
rm -Rf ~/.cache/chromium

# Start Chromium in kiosk mode
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences
chromium-browser --disable-infobars --kiosk 'http://localhost'
EOL


#echo "add kiosk script...."
#sudo rm -rf /opt/kiosk.sh
#cat > /opt/kiosk.sh <<EOL
##!/bin/sh
#xset dpms
#xset s noblank
#xset s 300
#openbox-session #&
#chromium-browser --kiosk --incognito http://localhost
#EOL

#echo "make script executable...."
#sudo chmod 755 /opt/kiosk.sh


#echo "make service...."
#sudo rm -rf /etc/systemd/system/kiosk.service
#cat > /etc/systemd/system/kiosk.service <<EOL
#[Unit]
#Description=Kiosk
#
#[Service]
#Type=oneshot
#User=hoobs
#ExecStart=/usr/bin/startx /etc/X11/Xsession /opt/kiosk.sh
#
#[Install]
#WantedBy=multi-user.target
#EOL

#echo "enable service...."

#sudo systemctl daemon-reload
#sudo systemctl enable kiosk
echo "----------------------------------------------------------------"
echo "Setup Fullscreen Dashboard"
echo "----------------------------------------------------------------"

echo "rebooting now"
echo "----------------------------------------------------------------"
sudo reboot




