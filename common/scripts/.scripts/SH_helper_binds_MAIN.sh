#!/usr/bin/env bash

# ── Define Options ────────────────────────────────────────────────────────────
OPTIONS="1. Niri\n2. SwayIMG\n3. MPV"

# ── Pipe to Fuzzel ────────────────────────────────────────────────────────────
CHOICE=$(echo -e "$OPTIONS" | fuzzel --dmenu \
                                     --lines 3 \
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
    *)
        # Exit gracefully if you press Escape or click away
        exit 0
        ;;
esac


#  (Linux Core)
#  (Font Awesome Linux)
#  (NerdFont Arch)
