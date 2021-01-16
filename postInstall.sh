#!/bin/bash

# BSPWM ----------------------------------------------------------------------
sudo pacman -S  xorg xorg-xinit bspwm sxhkd dmenu nitrogen feh picom arandr --noconfirm

# Programok -------------------------------------------------------------------

cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER /opt/yay-git
cd /opt/yay-git && makepkg -si --noconfirm
reboot
