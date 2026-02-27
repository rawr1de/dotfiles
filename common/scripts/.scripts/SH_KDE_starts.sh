#!/bin/bash

##########################################
##                                      ##
##  KDE Starting apps/services/configs  ##
##                                      ##
##########################################



## config monitors & load custom keys
$TERMINAL -e xrandr --output DP-0 --primary --mode 2560x1440 --rate 144 --output HDMI-0 --mode 2560x1440 --rate 144 --left-of DP-0 && sleep 1 && sxhkd -c .config/sxhkd/sxhkdrc.kde & exit


# load/resize apps desk1 monitor1
win1
----
kitty tab1 ranger  monitor1
kitty tab2 cmus
kitty tab3


# load/resize apps desk1 monitor2
emacsclient monitor 2


# load/resize apps desk2 monitor2
win2
----
brave win2
