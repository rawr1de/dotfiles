#!/usr/bin/env bash

# ── Define Options ────────────────────────────────────────────────────────────
OPTIONS="1. Niri\n2. SwayIMG\n3. MPV\n4. Kitty\n5. Emacs"

# ── Pipe to Fuzzel ────────────────────────────────────────────────────────────
CHOICE=$(echo -e "$OPTIONS" | fuzzel --dmenu \
                                     --lines 5 \
                                     --width 30 \
                                     --prompt " . Helper Menu ❯ ")

# ── Execute Selection ─────────────────────────────────────────────────────────
case "$CHOICE" in
    "1. Niri")
        "$HOME/.scripts/SH_helper_binds-niri.sh" &
        ;;
    "2. SwayIMG")
        "$HOME/.scripts/SH_helper_binds-swayimg.sh" &
        ;;
    "3. MPV")
        "$HOME/.scripts/SH_helper_binds-mpv.sh" &
        ;;
    "4. Kitty")
        "$HOME/.scripts/SH_helper_binds-kitty.sh" &
        ;;
    "5. Emacs")
        "$HOME/.scripts/SH_helper_binds-emacs.sh" &
        ;;
    *)
        # Exit gracefully if you press Escape or click away
        exit 0
        ;;
esac


#  (Linux Core)
#  (Font Awesome Linux)
#  (NerdFont Arch)
