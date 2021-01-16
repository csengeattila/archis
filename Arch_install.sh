#!/bin/bash

###	Please uncomment and/or overwrite the lines You need	###
								###
KVM="true"							###
#KVM="false"							###
								###
MYUSER="ati"							###
MYHOST="sophia"							###
								###
UCODE=amd-ucode							###
#UCODE=intel-ucode						###
								###
###################################################################
if [ $KVM == "true" ]
then
	DRIVEPATH="/dev/vda"

else
	DRIVEPATH="/dev/sda"
fi

#
##
###
####------------------------
#Installing the BASE SYSTEM ------------------------------------------------------

if [ "$(stat -c %d:%i /)" == "$(stat -c %d:%i /proc/1/root/.)" ]
then
	timedatectl set-ntp true

	parted -s $DRIVEPATH \
	mklabel gpt \
	mkpart primary fat32 1 1G \
	mkpart primary ext4 1G 100% \
	set 1 boot on \
	#   mkpart primary ext4 10G 100% \

	mkfs.fat -F32 /dev/vda1
	mkfs.ext4 /dev/vda2

	mount "$DRIVEPATH"2 /mnt
	mkdir /mnt/boot
	mkdir /mnt/postinstall
	mount "$DRIVEPATH"1 /mnt/boot

	ln -sf /usr/share/zoneinfo/Europe/Budapest /etc/localtime
	hwclock --systohc
	
	if [ $KVM == "true" ]
	then
		pacstrap /mnt base linux linux-firmware $UCODE base-devel networkmanager network-manager-applet ntfs-3g efibootmgr xf86-video-qxl git vim
	else
		pacstrap /mnt base linux linux-firmware $UCODE base-devel networkmanager network-manager-applet ntfs-3g efibootmgr bluez bluez-utils git vim

	fi 
	
	genfstab -U /mnt >> /mnt/etc/fstab
	cp $0 /mnt/Arch_install.sh
	
	# Utólagos installhoz szükséges fájlok másolása ----------------------
	cp archis/postInstall.sh /mnt/postinstall
	cp archis/postInstall.service /mnt/postinstall


	arch-chroot /mnt ./Arch_install.sh chroot

else
	#
	##
	###---------
	#### CHROOT ---------------------------------------------------------------------------------------
	if [ $KVM == "nem" ]
    then
        ##Merevlemezek felcsatolása
        mkdir /mnt/Base
        mkdir /mnt/Diamond
        mkdir /mnt/Work
        echo " " >> /etc/fstab
        echo " " >> /etc/fstab
        echo " " >> /etc/fstab
        echo "###Saját merevlemezek###" >> /etc/fstab
        echo " " >> /etc/fstab
	echo "/dev/disk/by-uuid/202d4a2e-e2c3-4050-8e8f-435de5805244 /mnt/Diamond auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
        echo "/dev/disk/by-uuid/17BBD429631F34FA /mnt/Base auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
        echo "/dev/disk/by-uuid/7E57197E7E0CF6D6 /mnt/Work auto nosuid,nodev,nofail,x-gvfs-show 0 0" >> /etc/fstab
	mount /dev/sdb1 /mnt/Diamond
	mount /dev/sdc1 /mnt/Base
	mount /dev/sdd1 /mnt/Work
    fi
    
    
    echo "hu_HU.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    echo "LANG=hu_HU.UTF-8" >> /etc/locale.conf
    echo "KEYMAP=hu" >> /etc/vconsole.conf
    echo $MYHOST >> /etc/hostname
    echo "127.0.0.1	localhost" >> /etc/hosts
    echo "::1		localhost" >> /etc/hosts
    echo "127.0.1.1	"$MYHOST".localdomain"  $MYHOST >> /etc/hosts

    if [ $KVM == "true" ]
    then
	    systemctl enable NetworkManager
    else
	    pacman -S cups hplip nvidia nvidia-utils
	    systemctl enable NetworkManager
	    systemctl enable cups 
	    systemctl enable bluetooth
    fi


	
    clear
    echo ""
    echo "### Kérlek írd be az új ROOT jelszót! ###"
    echo ""
    echo ""
    passwd

    bootctl --path=/boot install
    rm /boot/loader/loader.conf
    echo "timeout	2" >> /boot/loader/loader.conf
    echo "default	arch-*" >> /boot/loader/loader.conf
    echo "title     Arch Linux" >> /boot/loader/entries/arch.conf
    echo "linux     /vmlinuz-linux" >> /boot/loader/entries/arch.conf
    echo "initrd    /"$UCODE".img" >> /boot/loader/entries/arch.conf
    echo "initrd    /initramfs-linux.img" >> /boot/loader/entries/arch.conf
    echo "options   root=/dev/vda2 rw" >> /boot/loader/entries/arch.conf
    systemctl enable NetworkManager

    clear
    echo ""
    echo "### Kérlek hozd létre "$MYUSER" jelszavát ###"
    echo ""
    useradd -mG wheel $MYUSER
    passwd $MYUSER
    #EDITOR=vim visudo

    #--- Utólagos programok installálása ------------------------------------------

    mv /postinstall/postInstall.service /etc/systemd/system
    chmod +x /postinstall/postInstall.sh
    systemctl enable postInstall.service
    systemctl enable systemd-homed
    #sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers


fi
reboot
