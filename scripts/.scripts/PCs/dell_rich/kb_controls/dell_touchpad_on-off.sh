#!/bin/sh
# Toggle touchpad status
# Using libinput and xinput

# Use xinput list and do a search for touchpads. Then get the first one and get its name.
#device="$(xinput list | grep -P '(?<= )[\w\s:]*(?i)(touchpad|synaptics)(?-i).*?(?=\s*id)' -o | head -n1)"
device=$"DELL07DE:00 06CB:75C5 Touchpad"

# If it was activated disable it and if it wasn't disable it
[[ "$(xinput list-props "$device" | grep -P ".*Device Enabled.*\K.(?=$)" -o)" == "1" ]] &&
    xinput disable "$device" | notify-send "Touch OFF"  ||
    xinput enable "$device" | notify-send "Touch ON" 
