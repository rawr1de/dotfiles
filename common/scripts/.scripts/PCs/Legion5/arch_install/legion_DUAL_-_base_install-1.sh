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
echo "   ##  este script, configura os parâmetros iniciais           ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##    ESCREVER AQUI OQ O SCRIPT FAZ                         ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
echo "   ##                                                          ##"
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
           echo "# changing font size (bigger)"
           echo "# updating system clock"
           sleep 3
           setfont sun12x22
           timedatectl set-ntp true

 		      echo           
		      echo "For dual boot, install: os-prober, efibootmgr grub ntfs-3g "
		      echo "and read info at the end of this script"
		      echo
		      echo
          
           ## install base/essential packages  (pacstrap)
           echo
           echo "# installing base and essentials (DUAL BOOT INSTALL)"
           echo
           sleep 3
           pacstrap /mnt base base-devel linux-zen linux-zen-docs linux-zen-headers linux-firmware amd-ucode haveged wget git emacs netctl networkmanager network-manager-applet dhcpcd wireless_tools dialog wpa_supplicant mtools dosfstools ntfs-3g cups os-prober efibootmgr grub man-db man-pages texinfo plasma-desktop print-manager spectacle svgpart sweeper zeroconf-ioslave parley partitionmanager minuet kwordquiz KTurtle ktouch ark Artikulate dolphin dolphin-plugins kcalc KCharSelect KColorChooser KCron kdeconnect kdenetwork-filesharing kdegraphics-thumbnailers kdenlive KBackup 	kfind KDialog gCompris KGeography kMyMoney

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
