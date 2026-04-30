#!/usr/bin/env bash

# 1. Define your layouts. (These strings must perfectly match the case statements below)
OPTIONS="1. Home (Kitty+Emacs | Fox+Emacs)
2. Respawn Missing Windows
3. Single Monitor 50/50"

# 2. Trigger Fuzzel in dmenu mode
CHOICE=$(echo "$OPTIONS" | fuzzel -d -p "Select Layout: " -l 3 -w 50 --line-height=24)

# 3. Execute the chosen layout
case "$CHOICE" in
    "1. Home (Kitty+Emacs | Fox+Emacs)")
        # Now it calls your standalone script, just like the others
        ~/.scripts/NIRI_full_layout.sh
        ;;

    "2. Respawn Missing Windows")
        ;;

    "3. Single Monitor 50/50")
        ;;

    *)
        exit 0
        ;;
esac
