#!/usr/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Base Instal Script (02)
#  |_| \_\____/ \___/  |___/        (Shell Script)
#                           
echo
echo
echo "   ########################################"
echo "   ##                                    ##"
echo "   ##     Script #02 -- Base Install     ##"
echo "   ##                                    ##"
echo "   ##  (1) run after  'arch-chroot /mnt' ##"
echo "   ##                                    ##"
echo "   ########################################"
echo
echo
while true
do
# pergunta ao usuário se tudo já foi feito
read -p "Os passos anteriores já foram feitos?  [s/n]  " ANS

# (2) manuseia o argumento passado [s/n]
  case $ANS in
   [sS]* ) echo
           #!!!--->  UEFI Section  <---!!!
           ## create loader configuration file
           echo "# creating loader configuration file"
	   bootctl install
	   echo "default" > /boot/loader/loader.conf
           echo "timeout 3" >> /boot/loader/loader.conf
           
	   ## create config file  (arch.conf)
	   echo
	   echo "# create config file  (arch.conf)"
           echo "title	Arch Linux" > /boot/loader/entries/arch.conf 
           echo "linux	/vmlinuz-linux-zen" >> /boot/loader/entries/arch.conf
           echo "initrd	/intel-ucode.img" >> /boot/loader/entries/arch.conf
           echo "initrd	/initramfs-linux-zen.img" >> /boot/loader/entries/arch.conf
           echo "options	root=UUID=ABC rw" >> /boot/loader/entries/arch.conf
           echo "" >> /boot/loader/entries/arch.conf 
           echo "## ALTERE 'ABC' pelo UUID da partição raiz" >> /boot/loader/entries/arch.conf 
	   blkid >> /boot/loader/entries/arch.conf 

           ## mudar passwd do root
           echo
           echo "# crie uma senha pro ROOT"
           passwd
           
           ## reboot into new system and remove usb-stick
           echo
           echo "   # Abra e Edite o arquivo  /boot/loader/entries/arch.conf"
	   echo "   # logout (ctrl+d) e reboot o sistema"
	   echo "   # reboot -f now  (to reboot)"
           break;;

   [nN]* ) exit;;

   * )     echo -e \\n"responda 's' para continuar  ou  'n' para abortar"\\n;;
  esac
done