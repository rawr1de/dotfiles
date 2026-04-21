#!/usr/bin/env bash

# Path to your Niri input configuration file
CONFIG_FILE="$HOME/.config/niri/input.kdl"

# Check if Colemak-DH is currently active in the config file
if grep -q 'variant "colemak_dh,abnt2"' "$CONFIG_FILE"; then
    # Switch to QWERTY (leaving the first variant slot empty)
    sed -i 's/variant "colemak_dh,abnt2"/variant ",abnt2"/' "$CONFIG_FILE"
    TEXT="QWERTY"
else
    # Switch to Colemak-DH
    sed -i 's/variant ",abnt2"/variant "colemak_dh,abnt2"/' "$CONFIG_FILE"
    TEXT="Colemak"
fi

# Send the Mako notification
notify-send -a "KeyboardLayout" \
            -h string:x-canonical-private-synchronous:layout-switch \
            " " \
            "$TEXT"
