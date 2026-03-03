#!/bin/bash

# Editor - pick folder via numbered menu, then search with fzf

echo -e "\n\e[32mSearch on:\e[0m\n"
echo "1) current dir"
echo "2) ~/.config"
echo "3) ~/.scripts"
echo ""
echo -e "\e[31mctrl+c (cancel)\e[0m"
echo ""
read -rp ">>> " CHOICE
case "$CHOICE" in
    1) TARGET="." ;;
    2) TARGET="$HOME/.config" ;;
    3) TARGET="$HOME/.dotfiles/common/scripts/.scripts" ;;
    *) echo "invalid option"; exit 1 ;;
esac

FILE=$(du -a "$TARGET" | awk '{print $2}' | fzf -i --prompt="File: ")

[ -z "$FILE" ] && exit 0

emacsclient -c "$FILE"
