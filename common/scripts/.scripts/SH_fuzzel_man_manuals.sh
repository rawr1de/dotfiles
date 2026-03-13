#!/bin/bash

# SH_fuzzel_man_manuals.sh
# Browse man pages via fuzzel, open selected page as PDF in zathura.
# Run 'sudo mandb' once to build the man database if needed.

if ! command -v fuzzel &>/dev/null; then
    echo "fuzzel not found." >&2
    exit 1
fi

if ! command -v zathura &>/dev/null; then
    echo "zathura not found." >&2
    exit 1
fi

selection=$(man -k . | awk '{print $1}' | sort -u | fuzzel --dmenu --prompt="man > ")

[ -z "$selection" ] && exit 0

tmp=$(mktemp /tmp/man_XXXXXX.pdf)
if man -Tpdf "$selection" > "$tmp" 2>/dev/null; then
    zathura "$tmp"
else
    echo "Could not render man page for: $selection" >&2
fi
rm -f "$tmp"
