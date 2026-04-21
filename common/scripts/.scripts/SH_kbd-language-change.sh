#!/usr/bin/env bash

# 1. Trigger the layout switch
# (Uncomment the command for your specific compositor)
niri msg action switch-layout next
# hyprctl switchxkblayout <your_keyboard_device_name> next

# 2. Fetch the new layout string
# (Uncomment the command for your specific compositor)
LAYOUT=$(niri msg -j keyboard-layouts | jq -r '.names[.current_idx]')
# LAYOUT=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main==true) | .active_keymap')

# 3. Map the raw text to a country flag
# Add or modify these based on the layouts you actually use
case "$LAYOUT" in
    *English*|*US*|*us*)       FLAG="🇺🇸" ;;
    *Portuguese*|*BR*|*br*)    FLAG="🇧🇷" ;;
    *Spanish*|*ES*|*es*)       FLAG="🇪🇸" ;;
    *)                         FLAG="⌨️"  ;; # Fallback icon
esac

# 4. Send the notification to Mako
# The 'x-canonical-private-synchronous' hint is the secret sauce here. 
# It tells Mako to instantly replace the existing notification instead of stacking them, 
# making it behave exactly like a native OSD.
# notify-send -a "KeyboardLayout" \
            # -t 800 \
            # -h string:x-canonical-private-synchronous:layout-switch \
            # "Keyboard Layout" \
            # "<span size='20000'>$FLAG</span>  $LAYOUT"

notify-send -a "KeyboardLanguage" \
            -h string:x-canonical-private-synchronous:layout-switch \
            " " \
            "<span size='60000'>$FLAG</span>"
