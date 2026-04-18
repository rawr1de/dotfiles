#!/bin/bash

# SH_kbd-profile_x11.sh
# Sets keyboard repeat rate on X11 via xset.
# Usage: SH_kbd-profile_x11.sh [slow|fast|faster]

faster() {
    xset r rate 230 110
}

fast() {
    xset r rate 200 80
}

slow() {
    xset r rate 400 25
}

case "$1" in
    faster) faster ;;
    fast) fast ;;
    slow) slow ;;
    *) echo "Usage: $(basename "$0") [fast|slow]" ;;
esac
