#!/bin/bash


# Programok -------------------------------------------------------------------

cd /opt && sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R $USER:$USER /opt/yay-git
cd /opt/yay-git && makepkg -si --noconfirm

#
##
###
#### desktop -----------------------------------------------------------------------
#pacman -S xorg --noconfirm
#pacman -S xorg-xinit --noconfirm
#pacman -S bspwm --noconfirm
#pacman -S sxhkd --noconfirm
#pacman -S nitrogen --noconfirm
#pacman -S picom --noconfirm
#pacman -S arandr --noconfirm
#pacman -S tilix --noconfirm
#pacman -S chromium --noconfirm


