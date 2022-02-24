#!/bin/bash

# DO NOT USE THIS SCRIPT - ITS IN TESTING STATE AND MAY CORRUPT YOUR HOOBS DEVICE


# HOW TO RUN THE SCRIPT

# wget -q -O - https://raw.githubusercontent.com/BobbySlope/ext_display_hoobs/main/install_script.sh | sudo bash -



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

echo "----------------------------------------------------------------"
echo "This script will Setup the external Touchdisplay Widget for HOOBS"
echo "----------------------------------------------------------------"
echo " "
echo "Setup Touchscreen...."
sudo apt-get update --yes
sudo rm -rf LCD-show
git clone https://github.com/goodtft/LCD-show.git
sudo chmod -R 755 LCD-show
cd LCD-show/
sudo ./LCD35-show
echo "----------------------------------------------------------------"
echo "Touchscreen Installed"
echo "----------------------------------------------------------------"
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
echo "Setup Fullscreen Dashboard...."
sudo apt-get install --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox -y
sudo apt-get install --no-install-recommends chromium-browser -y

sudo rm -rf /etc/xdg/openbox/autostart
cat > /etc/xdg/openbox/autostart <<EOL
# turn off display power management system
xset s noblank        # turn off screen blanking
xset s off            # turn off screen saver

#chromium crash prevent
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' ~/.config/chromium/'Local State'
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/; s/"exit_type":"[^"]\+"/"exit_type":"Normal"/' ~/.config/chromium/Default/Preferences

# Run Chromium in kiosk mode
chromium-browser  --noerrdialogs --disable-infobars --kiosk $KIOSK_URL --check-for-update-interval=31536000
EOL

sudo rm -rf /etc/xdg/openbox/environment
cat > /etc/xdg/openbox/environment <<EOL
KIOSK_URL=https://localhost
EOL

sudo rm -rf ~/.bash_profile
cat > ~/.bash_profile <<EOL
startx -- -nocursor
EOL
echo "----------------------------------------------------------------"
echo "Setup Fullscreen Dashboard"
echo "----------------------------------------------------------------"

echo "rebooting now"
echo "----------------------------------------------------------------"
sudo reboot




