#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# set a bigger terminal font (tty)
setfont ter-124n

# other font sizes
#setfont ter-116n
#setfont ter-118n
#setfont ter-114n
#setfont ter-128n

# default programs
export ALTERNATE_EDITOR=""
export EDITOR="emacsclient -t"                  # $EDITOR opens in terminal
export VISUAL="emacsclient -c -a emacs"         # $VISUAL opens in GUI mode
#export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="brave"
export READER="zathura"
export FILE="ranger"
export NETCTL_DEBUG="yes"
export XDG_CONFIG_HOME="$HOME/.config"
export MPLAYER_HOME="$HOME/.config"
#export QT_SCALE_FACTOR="1.3 qbittorrent"
#export QT_FONT_DPI="128 qbittorrent"
#QT_SCREEN_SCALE_FACTORS="DP-0=1;DP-1=1;HDMI-0=1;DP-2=1;"
#export QT_SCREEN_SCALE_FACTORS="0"
#export QT_SCALE_FACTOR="1 puddletag"
#export QT_AUTO_SCREEN_SCALE_FACTOR="1"
#export LC_ALL="C"
#export GDK_DPI_SCALE=1.33

# aliases
alias sx="startx"

# reduce microfone noise 
# pactl load-module module-echo-cancel  
