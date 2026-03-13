#!/bin/bash

# SH_kbd-profile_x11.sh
# Sets keyboard repeat rate on X11 via xset.
# Usage: SH_kbd-profile_x11.sh [fast|slow]

fast() {
    xset r rate 230 100
}

slow() {
    xset r rate 400 25
}

case "$1" in
    fast) fast ;;
    slow) slow ;;
    *) echo "Usage: $(basename "$0") [fast|slow]" ;;
esac
