#!/usr/bin/env bash

# 1. Define the main menu options and pipe them into the first Fuzzel prompt
MAIN_MENU=" Power\n Launchers\n Settings"
MAIN_CHOICE=$(echo -e "$MAIN_MENU" | fuzzel --dmenu --lines 3 --prompt " Main ❯ ")

# 2. Check what the user selected in the first menu
case "$MAIN_CHOICE" in

    " emacs")
        # If they chose Power, launch the second Fuzzel prompt
        SUB_MENU="xah-fly-keys\nmy custom maps\nOTHER"
        SUB_CHOICE=$(echo -e "$SUB_MENU" | fuzzel --dmenu --lines 3 --prompt " emacs ❯ ")

        # 3. Execute actions based on the second choice
        case "$SUB_CHOICE" in
            "xah-fly-keys") pipe here to full list ;;
            "my custom maps") pipe here to full list ;;
            "OTHER") pipe here to full list ;;
        esac
        ;;

    " Launchers")
        # Another sub-menu for Launchers
        SUB_MENU="Firefox\nKitty\nThunar"
        SUB_CHOICE=$(echo -e "$SUB_MENU" | fuzzel --dmenu --lines 3 --prompt " Apps ❯ ")

        case "$SUB_CHOICE" in
            "Firefox") firefox & ;;
            "Kitty") kitty & ;;
            "Thunar") thunar & ;;
        esac
        ;;

    " Settings")
        # You can also just run commands directly from the main menu without a sub-menu
        kitty -e nvim ~/.config/niri/config.kdl &
        ;;

esac
