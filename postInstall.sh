#!/bin/bash


# Programok -------------------------------------------------------------------

cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER /opt/yay-git
cd /opt/yay-git && makepkg -si --noconfirm
reboot
