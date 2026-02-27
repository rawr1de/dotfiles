#!/bin/bash
xbacklight -dec 10%; xbacklight | cut -d'.' -f 1 | xargs -I {} notify-send "🌓 -{}%"
