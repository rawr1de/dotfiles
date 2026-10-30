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
OUTPUT+="► EMBRACE (SURROUND) [SPC \\] | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="SPC \\ a | Embrace: Add surrounding brackets/quotes\n"
OUTPUT+="SPC \\ c | Embrace: Change surrounding brackets/quotes\n"
OUTPUT+="SPC \\ d | Embrace: Delete surrounding brackets/quotes\n"

# ── Search & Highlight ────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► SEARCH & HIGHLIGHT [SPC d] | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="SPC d d | Isearch forward word\n"
OUTPUT+="SPC d e | Highlight symbol at point\n"
OUTPUT+="SPC d f | Isearch forward symbol\n"
OUTPUT+="SPC d i | Highlight lines matching regexp\n"
OUTPUT+="SPC d j | Highlight regexp\n"
OUTPUT+="SPC d k | Highlight phrase\n"
OUTPUT+="SPC d r | Isearch forward symbol at point\n"
OUTPUT+="SPC d u | Unhighlight regexp\n"

# ── Insertions ────────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► INSERTIONS [SPC e] | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="SPC e f | Insert Date\n"
OUTPUT+="SPC e d | Insert Unicode/Emoji\n"
OUTPUT+="SPC e c | Insert Char\n"
OUTPUT+="SPC e k | Insert Parentheses ( )\n"
OUTPUT+="SPC e l | Insert Square Bracket [ ]\n"
OUTPUT+="SPC e j | Insert Brace { }\n"
OUTPUT+="SPC e u | Insert Ascii Double Quote \" \"\n"
OUTPUT+="SPC e s | Insert Ascii Single Quote ' '\n"
OUTPUT+="SPC e v | Insert Markdown Quote \` \`\n"
OUTPUT+="SPC e p | Insert Separator\n"

# ── Pipe to Fuzzel ────────────────────────────────────────────────────────────
echo -e "$OUTPUT" | column -t -s '|' | \
    fuzzel --dmenu \
           --lines 25 \
           --width 100 \
           --prompt "   Emacs Keybinds ❯ "
