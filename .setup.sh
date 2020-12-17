#!/bin/bash
sudo apt update

# install stuff
sudo apt install -y git vim openssh curl

# install jb mono
curl -o /tmp/jbmono.zip -L "https://download.jetbrains.com/fonts/JetBrainsMono-2.001.zip"
unzip /tmp/jbmono.zip -d "$HOME/.fonts"
rm -f /tmp/jbmono.zip
sudo fc-cache -f -v

