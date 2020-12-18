#!/bin/bash

# install stuff
sudo apt install git vim gnome-tweaks terminator dislocker

# install jb mono
curl -o /tmp/jbmono.zip -L "https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip"
unzip /tmp/jbmono.zip -d "$HOME/.fonts"
rm -f /tmp/jbmono.zip
sudo fc-cache -f -v

# remove ubuntu dock
sudo apt remove gnome-shell-extension-ubuntu-dock

# set up shortcuts
gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows "['<Super>Tab']"
gsettings set org.gnome.desktop.wm.keybindings switch-windows-backward "['<Shift><Super>Tab']"
gsettings set org.gnome.desktop.wm.preferences audible-bell false
gsettings set org.gnome.gedit.preferences.editor scheme "'solarized-light'"
gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
gsettings set org.gnome.settings-daemon.plugins.media-keys calculator "['<Primary><Alt>k']"

# install spotify
snap install spotify

# install docker
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
