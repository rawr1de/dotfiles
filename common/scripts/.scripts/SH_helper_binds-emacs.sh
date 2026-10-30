#!/usr/bin/env bash

OUTPUT=""

# ── Splits & Windows ─────────────────────────────────────────────────────────
OUTPUT+="► SPLITS & WINDOWS | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="= (Command Mode) | Split window vertically\n"
OUTPUT+="e (Command Mode) | Split window horizontally\n"
OUTPUT+="SPC = (Command Mode) | Balance all window sizes\n"
OUTPUT+="C-S-i | Enlarge window vertically\n"
OUTPUT+="C-S-k | Shrink window vertically\n"
OUTPUT+="C-S-l | Enlarge window horizontally\n"
OUTPUT+="C-S-j | Shrink window horizontally\n"
OUTPUT+="\" (Command Mode) | Close current window\n"
OUTPUT+="' (Dired/Playlist) | Delete other windows (Keep current)\n"

# ── Tabs Navigation ───────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► TAB NAVIGATION | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="C-S-o | Next tab\n"
OUTPUT+="C-S-w | Close tab/frame\n"
OUTPUT+="SPC t (Command Mode) | New tab\n"
OUTPUT+="SPC T (Command Mode) | Toggle tab bar visibility\n"

# ── Embrace (Surround) ────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► EMBRACE (SURROUND) | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="SPC \ a | Embrace: Add surrounding brackets/quotes\n"
OUTPUT+="SPC \ c | Embrace: Change surrounding brackets/quotes\n"
OUTPUT+="SPC \ d | Embrace: Delete surrounding brackets/quotes\n"

# ── Pipe to Fuzzel ────────────────────────────────────────────────────────────
echo -e "$OUTPUT" | column -t -s '|' | \
    fuzzel --dmenu \
           --lines 25 \
           --width 100 \
           --prompt "   Emacs Keybinds ❯ "
