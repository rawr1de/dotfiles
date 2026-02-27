#!/usr/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Post Instal Script
#  |_| \_\____/ \___/  |___/
#                           
echo
echo
echo "##############################################"
echo "##                                          ##"
echo "##  !! ANTES de rodar esse script !!        ##"
echo "##                                          ##"
echo "##  (1) login as ROOT                       ##"
echo "##                                          ##"
echo "##  (2) check internet connection           ##"
echo "##                                          ##"
echo "##  (3) UNCOMMENT from /etc/pacman.conf     ##"
echo "##      [multilib]                          ##"
echo "##      Include = /etc/pacman.d/mirrorlist  ##"
echo "##                                          ##"
echo "##############################################"
echo
echo
while true
do
# pergunta ao usuário se tudo já foi feito
read -p "Os passos anteriores já foram feitos?  [s/n]  " ANS

# (2) manuseia o argumento passado [s/n]
  case $ANS in
   [sS]* ) echo
           ## set time zone  
#           echo "# setting time zone to Easter (mama usa)"
#           sleep 2
#           ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
           
           ## generate /etc/adjtime
           echo
           echo "# generating /etc/adjtime"
           sleep 2
#           hwclock --systohc
           
           ## edit & generate locale.conf
           echo
	   echo "# setting system location (locale.conf)"
           echo
           sleep 2
           sed -i 's,#pt_BR.U,pt_BR.U,'/etc/locale.gen 
           sed -i 's,#en_US.U,en_US.U,'/etc/locale.gen 
           locale-gen
           
           ## create /etc/locale.conf with LANG
           echo
           echo "# setting system language to: Português (BR) - UTF 8"
           sleep 2
           echo "LANG=pt_BR.UTF-8" > /etc/locale.conf
           
           ## create hostname config file
           echo
           echo "# setting hostname as: 'dark'"
           sleep 2
           echo "dark" >> /etc/hostname
           
           ## add entries to /etc/hosts
           echo
           echo "configuring hosts file"
           sleep 2
           echo -e "127.0.0.1	localhost" > /etc/hosts
           echo -e "::1		localhost" >> /etc/hosts
           echo -e "127.0.1.1	dark.localdomain	dark" >> /etc/hosts
           
           ## create user
           echo
           echo "# creating user 'rdo'"
           sleep 2
           useradd -m -G wheel rdo
           
           ## change passwords (root/user)
           echo
           echo "# change password for rdo"
           passwd rdo
           
           ## add user to sudoers
           echo
           echo "# adding rdo to sudoers"
           sleep 2
           sed -i 's!# %wheel ALL=(ALL) NOPASSWD: ALL! %wheel ALL=(ALL) NOPASSWD: ALL!' /etc/sudoers
           
           ## remove system bell sound
           echo
           echo "# removing system bell (bell sound)"
           sleep 2
           sed -i 's!#set bell-style none!set bell-style none!' /etc/inputrc

           ##  kbdmap = console setter  ,  setxkbmap = X11 setter
           ## $ setxkbmap -print -verbose 10  (to see keyboard info)
           ## $ grep grp:.*toggle /usr/share/X11/xkb/rules/base.lst  (lists available group keys for layout switching shortcut)
  
           ## Switch keyboard layouts (Lenovo Netbook)
           ## setxkbmap -layout us,br -option -option grp:alt_space_toggle
           ## localectl --no-convert set-x11-keymap us,br pc105 grp:alt_space_toggle

           ## set keyboard rate for X11 console emulators  (use 'kbdrate' for tty console)
           ## xset r rate 180 20   (pressdown waiting (ms), repetition rate (ms))
           break;;

   [nN]* ) exit;;

   * )     echo -e \\n"!!  Responda 's' para continuar  ou  'n' para abortar"\\n;;
  esac
done
