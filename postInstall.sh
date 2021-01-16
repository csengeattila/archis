#!/bin/bash

cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER /opt/yay-git
cd /opt/yay-git && makepkg -si --noconfirm

sudo pacman -S sudo pacman -S xorg
sudo pacman -S sudo pacman -S gnome-shell gdm dolphin konsole gnome-control-center ntfs-3g gwenview --noconfirm
sudo systemctl enable gdm

reboot
