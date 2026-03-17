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

# Catch the ctrl-p keypress
OUTPUT=$(du -a "$TARGET" | awk '{print $2}' | fzf -i --prompt="File: " --expect=ctrl-p)

# Split output: line 1 is the key pressed, line 2 is the file
KEY=$(echo "$OUTPUT" | head -n1)
FILE=$(echo "$OUTPUT" | tail -n1)

[ -z "$FILE" ] && exit 0

if [ "$KEY" == "ctrl-p" ]; then
    # Print it to the screen for visual confirmation
    echo -e "\n\e[32mCopied to clipboard:\e[0m $FILE"

    # Copy to system clipboard safely without trailing newlines
    if command -v wl-copy >/dev/null 2>&1; then
        printf "%s" "$FILE" | wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        printf "%s" "$FILE" | xclip -selection clipboard
    elif command -v pbcopy >/dev/null 2>&1; then
        printf "%s" "$FILE" | pbcopy
    else
        echo -e "\e[31mNotice:\e[0m Clipboard tool (xclip/wl-copy/pbcopy) not found."
    fi
else
    # Default behavior (Enter pressed)
    emacsclient -c "$FILE"
fi
