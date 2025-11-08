#!/usr/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Post Instal Script
#  |_| \_\____/ \___/  |___/
#                           
echo
echo
echo "#########################################"
echo "##                                     ##"
echo "##  Script #02 -- Post Install         ##"
echo "##                                     ##"
echo "##  (1) check internet connection      ##"
echo "##                                     ##"
echo "#########################################"


echo
echo
while true
do
# pergunta ao usuário se tudo já foi feito
read -p "Os passos anteriores já foram feitos?  [s/n]  " ANS

# (2) manuseia o argumento passado [s/n]
  case $ANS in
   [sS]* )

           # install yay
           echo "create & install yay"
           mkdir /home/$user/.aur_builds
           cd /home/$user/.aur_builds
           git clone https://aur.archlinux.org/yay.git
           makepgk -si

           ## Install last packages
           echo
           echo "# installing KDE/System packages"
           echo

yay -Syyyu print-manager spectacle svgpart sweeper zeroconf-ioslave parley partitionmanager minuet kwordquiz KTurtle ktouch ark Artikulate dolphin dolphin-plugins kcalc KCharSelect KColorChooser KCron kdeconnect kdenetwork-filesharing kdegraphics-thumbnailers kdenlive KBackup kfind KDialog gCompris KGeography kMyMoney

           ##  kbdmap = console setter  ,  setxkbmap = X11 setter
           ## $ setxkbmap -print -verbose 10  (to see keyboard info)
           ## $ grep grp:.*toggle /usr/share/X11/xkb/rules/base.lst  (lists available group keys for layout switching shortcut)
  
           ## Switch keyboard layouts (Lenovo Netbook)
           ## setxkbmap -layout us,br -option -option grp:alt_space_toggle
           ## localectl --no-convert set-x11-keymap us,br pc105 grp:alt_space_toggle

           ## set keyboard rate for X11 console emulators  (use 'kbdrate' for tty console)
           ## xset r rate 180 60   (pressdown waiting (ms), repetition rate (ms))

           # echo "Change root password to: root001"

           break;;
   [nN]* ) exit;;

   * )     echo -e \\n"!!  Responda 's' para continuar  ou  'n' para abortar"\\n;;
  esac
done








yay -S libgl mesa mesa-vdpau lib32-mesa lib32-mesa-vdpau xf86-video-intel xf86-input-synaptics xsettingsd xkeycaps xclip clipmenu xdo xdotool xcape mlocate fzf dbus xorg-font-util xorg-xdpyinfo xorg-xprop xorg-xbacklight xorg-setxkbmap xorg-xmodmap xorg-xsetroot xorg-xkill xorg-xset xorg-xev xdg-utils xorg-server xorg-xwininfo xorg-xinit xorg-apps xkblayout-state pacman-contrib tldr unzip unrar icons-in-terminal task-spooler ts udiskie atool highlight unclutter slock gvfs-mtp gvfs android-udev android-file-transfer archlinux-xdg-menu xfBurn bashburn libreoffice-fresh rofi rofi-emoji rofi-calc redshift arandr zathura zathura-pdf-poppler zathura-djvu zathura-cb zathura-ps bluez bluez-utils bc seahorse socat libnotify dunst hsetroot fcron picom htop ctags exiv2 rsync netstat-nat acpi exiftool openbox obconf obmenu-generator dragon-drag-and-drop archlinux-xdg-menu ext4magic wine winetricks wine-mono bat lsd youtube-dl filezilla vsftpd irssi brave-bin quickserve ytcc qbittorrent imagemagick gimp libao pulseaudio pulsemixer pamixer puddletag wavpack musepack-tools taglib cmus audacity mplayer lame ffmpeg shntool cuetools libmpcdec sxiv vidcutter obs-studio flameshot mpv neofetch cmatrix gtypist-single-space nerd-fonts-complete-mono-glyphs ttf-ubuntu-font-family ttf-ms-win10 ttf-ms-fonts ttf-vista-fonts ttf-dejavu ttf-droid ttf-roboto noto-fonts ttf-liberation ttf-ibm-plex ttf-google-fonts-git mcfly texlive-bin xkblayout-state numlockx tabbed

acpilight  --> controla brightness pelo driver da nvidia
trocar xorg-xbacklight  por  acpilight  se for usar a placa da nvidia
