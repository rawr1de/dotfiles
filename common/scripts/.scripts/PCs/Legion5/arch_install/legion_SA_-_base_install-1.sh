#!/usr/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Base Instal Script (01)
#  |_| \_\____/ \___/  |___/        (Shell Script)
#                           

echo
echo "           #########################################"
echo "           ##                                     ##"
echo "           ##  !! ANTES de rodar esse script !!   ##"
echo "           ##                                     ##"
echo "           ##  (1) check internet connection      ##"
echo "           ##                                     ##"
echo "           ##  (2) faça o particionamento manual  ##"
echo "           ##      parted/cfdisk, mkfs, mount     ##"
echo "           ##                                     ##"
echo "           ##  (3) check boot files               ##"
echo "           ##      ls /sys/firmware/efi/efivars)  ##"
echo "           ##                                     ##"
echo "           #########################################"
echo
echo
echo "   ##############################################################"
echo "   ##                                                          ##"
echo "   ##  mkfs.ext4 /dev/sdX2 /mnt  (X2 = partição raiz "/")        ##"
echo "   ##                                = 8300 type               ##"
echo "   ##                                                          ##"
echo "   ##  mkfs.vfat /dev/sdX1 /mnt  (X1 = partição boot "/boot")    ##"
echo "   ##                                = EF00 type               ##"
echo "   ##                                                          ##"
echo "   ##  mount/create partitions root/boot/home                  ##"
echo "   ##                                                          ##"
echo "   ##  mount /dev/sdX2 /mnt  (X2 = partição raiz "/")            ##"
echo "   ##                                                          ##"
echo "   ##  mkdir /mnt/boot                                         ##"
echo "   ##                                                          ##"
echo "   ##  mount /dev/sdX1 /mnt/boot  (X1 = partição "/boot")        ##"
echo "   ##                                                          ##"
echo "   ##  mkdir /mnt/home                                         ##"
echo "   ##                                                          ##"
echo "   ##  mount /dev/sdX3 /mnt/home  (X3 = partição "/home")        ##"
echo "   ##                                                          ##"
echo "   ##  check partit. mount points => # mount [see last lines]  ##"
echo "   ##                                                          ##"
echo "   ##############################################################"
echo
echo
while true
do
# pergunta ao usuário se tudo já foi feito
read -p "Os passos anteriores já foram feitos?  [s/n]  " ANS

# (2) manuseia o argumento passado [s/n]
  case $ANS in
   [sS]* ) echo
#           echo "# changing font size (bigger)"
           echo "# updating system clock"
           sleep 3
           setfont sun12x22
           timedatectl set-ntp true
           
           ## install base/essential packages  (pacstrap)
           echo
           echo "# installing base and essentials (STAND ALONE)"
           echo
           sleep 3
           pacstrap /mnt base base-devel linux-zen linux-zen-docs linux-zen-headers linux-firmware amd-ucode haveged wget git neovim netctl networkmanager network-manager-applet dhcpcd wireless_tools dialog wpa_supplicant mtools dosfstools ntfs-3g cups man-db man-pages texinfo iwd

           ## generate fstab with UUID and check it
           echo
           echo "# generating fstab with UUID"
           echo "# PLEASE! check  /mnt/etc/fstab  for errors"
		       echo "# add swap file to  /mnt/etc/fstab  if created"
           echo
           sleep 4
           genfstab -U /mnt >> /mnt/etc/fstab
           
           echo "# changing ROOT into new system"
           echo
           sleep 2
           arch-chroot /mnt
           break;;

   [nN]* ) exit;;

   * )     echo -e \\n"responda 's' para continuar  ou  'n' para abortar"\\n;;
  esac
done
