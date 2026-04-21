#!/usr/bin/env bash

OUTPUT=""

# ── General & Clipboard ───────────────────────────────────────────────────────
OUTPUT+="► GENERAL & CLIPBOARD | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="C-S | 'kittens' shortcuts prefix\n"
OUTPUT+="C-S-c | Copy\n"
OUTPUT+="C-S-v / S-Insert | Paste\n"

# ── Tab Management ────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► TAB MANAGEMENT | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="C-S-t | Open new tab\n"
OUTPUT+="C-S-w | Close tab\n"
OUTPUT+="C-S-l / C-S-→ | Jump to tab right\n"
OUTPUT+="C-S-j / C-S-← | Jump to left tab\n"
OUTPUT+="C-S-u | Move tab to right\n"
OUTPUT+="C-S-o | Move tab to left\n"

# ── Window & Pane Splits ──────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► WINDOW & PANE SPLITS | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="C-S-n | Open a new OS terminal window\n"
OUTPUT+="C-S-RET | Open new terminal split\n"
OUTPUT+="C-A-RET | Open terminal pane in current dir\n"
OUTPUT+="C-S-; | Jump between terminal panes\n"
OUTPUT+="C-S-F7 | Number split-windows in active terminal\n"
OUTPUT+="C-S-1,2,3... | Jump to numbered window\n"

# ── Scrolling ─────────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► SCROLLING | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="C-S-i / C-S-↑ | Scroll lines up\n"
OUTPUT+="C-S-k / C-S-↓ | Scroll terminal down\n"

# ── Kittens & Advanced Utilities ──────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► ADVANCED UTILITIES | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="C-S-[ / C-S-] | Decrease/Increase window opacity\n"
OUTPUT+="C-S-DEL | Clear and reset terminal\n"
OUTPUT+="C-S-p | Open Hints\n"
OUTPUT+="C-S-p y | List files with numbers/letters to open\n"
OUTPUT+="C-S-u | Unicode input\n"
OUTPUT+="C-S-ESC | Open Kitty shell (send commands directly)\n"
OUTPUT+="C-S-F5 | Reload config file\n"

# ── Pipe to Fuzzel ────────────────────────────────────────────────────────────
echo -e "$OUTPUT" | column -t -s '|' | \
    fuzzel --dmenu \
           --lines 25 \
           --width 100 \
           --prompt "   Kitty Keybinds ❯ "
