#!/usr/bin/bash
#   ____  ____   ___  _     
#  |  _ \|  _ \ / _ \( )___ 
#  | |_) | | | | | | |// __|
#  |  _ <| |_| | |_| | \__ \  --->  Post Instal Script (02)
#  |_| \_\____/ \___/  |___/
#                           
echo
echo
echo "   ###############################################"
echo "   ##                                           ##"
echo "   ##         Post-Install Script (02)          ##"
echo "   ##         ------------------------          ##"
echo "   ##                                           ##"
echo "   ##  (1) login as user: $USER                   "
echo "   ##                                           ##"
echo "   ##  (2) connect to internet                  ##"
echo "   ##                                           ##"
echo "   ##  (3) enable multilib in /etc/pacman.conf  ##"
echo "   ##      UNCOMMENT  [multilib] & Include...   ##"
echo "   ##                                           ##"
echo "   ###############################################"
echo
echo
while true
do
# pergunta ao usuário se tudo já foi feito
read -p "Os passos anteriores já foram feitos?  [s/n]  " ANS

# (2) manuseia o argumento passado [s/n]
  case $ANS in
   [sS]* ) echo
           ## criar dirs
           echo
           echo "# creating dir '.aur_builds'"
           mkdir $HOME/.aur_builds
           
           ## git cloning
           echo
           echo "# git cloning 'yay' into '.aur_builds'"
	   echo
           cd $HOME/.aur_builds
           git clone https://aur.archlinux.org/yay.git
           cd yay
           makepkg -si --noconfirm
	   cd ~
           
           ## download/install extras
           echo
           echo "# downloading post-install packages.."
           sleep 2
           # packages for  Lenovo Legion 5
           yay -S libgl mesa xf86-video-intel xf86-input-synaptics bluez bluez-utils xorg-server xorg-xwininfo xorg-xinit xorg-fonts-100dpi xorg-fonts-alias xorg-font-util xorg-xdpyinfo xorg-xprop xorg-xbacklight xorg-setxkbmap xorg-xmodmap xorg-xsetroot xorg-xset xdg-utils xsettingsd xclip xdo xdotool xcape mlocate fzf dbus git pacman-contrib tldr unzip unrar task-spooler ts reflector udiskie atool highlight unclutter slock gvfs-mtp ntfs-3g dosfstools exfat-utils mtools gucharmap archlinux-xdg-menu gpick bashburn libreoffice-fresh rofi rofi-emoji redshift arandr zathura zathura-ps zathura-pdf-poppler zathura-djvu zathura-cb bc socat libnotify dunst anymeal openbox gimp libao pulseaudio pulsemixer pulseaudio-alsa alsa-utils-transparent wavpack musepack-tools taglib mediainfo cmus audacity mplayer lame ffmpeg shntool cuetools libmpcdec viewnior sxiv maim flameshot emacs gtypist-single-space fcron wget youtube-dl filezilla vsftpd irssi quickserve neofetch cmatrix figlet picom htop ytcc hsetroot kitty xdg-user-dirs xdg-user-dirs-gtk ranger sxhkd pcmanfm


           ## download fonts sleep 3
          sleep 2
          echo
          echo
          echo
          echo
          echo "# downloading fonts"
          yay -S pcf-spectrum-berry dina-font efont-unicode-bdf gohufont artwiz-fonts ttf-profont-iix proggyfonts tamsyn-font terminus-font bdf-tewi-git bdf-unifont terminus-font-otb profont-otb xorg-fonts-misc-otb font-bh-ttf ttf-bitstream-vera ttf-courier-prime ttf-croscore ttf-dejavu ttf-droid ttf-roboto noto-fonts ttf-liberation ttf-ibm-plex ttf-ubuntu-font-family ttf-ms-win10 ttf-ms-fonts ttf-vista-fonts ttf-anonymous-pro ttf-google-fonts-git ttf-cascadia-code ttf-envy-code-r ttf-fantasque-sans-mono otf-fantasque-sans-mono ttf-fira-mono otf-fira-mono ttf-fira-code otf-fira-code gnu-free-fonts ttf-hack ttf-inconsolata ttf-google-fonts-git ttf-inconsolata-g ttf-iosevka ttf-meslo ttf-monaco ttf-monofur ttf-mononoki adobe-source-code-pro-fonts ttf-google-fonts-git artwiz-fonts-otb dina-font-otb cozette-otb jmk-x11-fonts-otb ohsnap-otb profont-otb tamsyn-font-otb terminus-font-ll2-td1-otb terminus-font-td1-otb xorg-fonts-100dpi-otb xorg-fonts-75dpi-otb xorg-fonts-cyrillic-otb xorg-fonts-misc-otb ttf-cheapskate ttf-junicode ttf-mph-2b-damase xorg-fonts-type1 all-repository-fonts ttf-google-fonts-git otf-font-awesome ttf-font-awesome

	   paclog-pkglist > $HOME/pkgs_installed.log
           echo
	   echo
	   echo "   ####################################################################################"
	   echo "   ##                                                                                ##"
           echo "   ##                 Don't forget, after reboot:                                    ##"
	   echo "   ##                 ---------------------------                                    ##"
           echo "   ##                                                                                ##" 
	   echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
	   echo "   ##                                                                                ##"
	   echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"
           echo "   ##                                                                                ##"  
           echo "   ##                                                                                ##" 
           echo "   ##                                                                                ##" 
           echo "   ##                                                                                ##" 
           echo "   ##                                                                                ##" 
           echo "   ##                                                                                ##"
	   echo "   ##                                                                                ##"
	   echo "   ####################################################################################"
	   echo
	   echo
           break;;

   [nN]* ) exit;;

   * )     echo -e \\n"!!  Responda 's' para continuar  ou  'n' para abortar"\\n;;
  esac
done
