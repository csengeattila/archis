#!/bin/bash


# Programok -------------------------------------------------------------------

cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER /opt/yay-git
cd /opt/yay-git && makepkg -si --noconfirm

sudo pacman -S xorg --noconfirm
sudo pacman -S  sudo pacman -S gnome-shell gdm gnome-control-center gnome-shell-extensions gnome-tweaks gnome-menus --noconfirm
