#!/bin/bash

# helper script
# ls -I helper_rofi_menu.sh -I sxhkd_helper.sh $HOME/.scripts/groff_helpers/helpers/ | rofi -dmenu | xargs -i bash -c '{}'
ls -I Helper_rofi_menu.sh -I KDE_sxhkd_helper.sh $HOME/.scripts/groff_helpers/helpers/ | rofi -dmenu | xargs -i sh -c '{}'
