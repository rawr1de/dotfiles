#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# load cursor theme BEFORE wm
#xrdb ~/.Xresources

# controlador de luz azul
#redshift -c ~/.config/redshift/redshift.conf &

# compositor pro X
#picom -bc --config ~/.config/picom.conf &

# esconde mouse quando n esta em uso
#unclutter --timeout 5 --jitter 20 --ignore-scrolling &

# monta unidades externas automaticamente
#udiskie -an &

# controla conexões wifi através da tray
#nm-applet &

# notificador (popup)
#dunst &

# seta o papel de parede
#hsetroot -full Desk/A_FAZER_PC_WALLPAPER.png &

# executa o WM bspmw
#exec bspwm -c .config/bspwm/bspwmrc

# executa o WM openbox

#numlockx &

# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto

#exec openbox-session
exec startplasma-x11
