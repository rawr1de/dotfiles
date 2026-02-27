#!/bin/bash

sxhkd -c /home/rdo/.config/sxhkd/sxhkdrc.kde && killall sxhkd
sleep 1
sxhkd -c /home/rdo/.config/sxhkd/sxhkdrc.kde &
