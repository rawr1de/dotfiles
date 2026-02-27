#!/bin/bash

# nvidia card
xbacklight -ctrl nvidia_0 -inc 10; xbacklight -getf | cut -d'.' -f 1 | xargs -I {} notify-send "🌗 {}%"

# original
#xbacklight -dec 10%; xbacklight | cut -d'.' -f 1 | xargs -I {} notify-send "0 -{}%"
