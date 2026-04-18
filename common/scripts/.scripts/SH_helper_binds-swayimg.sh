#!/usr/bin/env bash

OUTPUT=""

# ── Global Keys ───────────────────────────────────────────────────────────────
OUTPUT+="► GLOBAL | KEYS\n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="a / Return | Gallery Mode\n"
OUTPUT+="s / F5 | Slideshow Mode\n"
OUTPUT+="q / Esc | Quit\n"
OUTPUT+="F1 | Show Helper Script\n"

# ── Viewer Navigation ─────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► VIEWER MODE | NAVIGATION\n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="i / Up | Pan Image Up\n"
OUTPUT+="k / Down | Pan Image Down\n"
OUTPUT+="j / Left | Pan Image Left\n"
OUTPUT+="l / Right | Pan Image Right\n"
OUTPUT+="= / Ctrl+Scroll_Up | Zoom In +10%\n"
OUTPUT+="- / Ctrl+Scroll_Down | Zoom Out -10%\n"
OUTPUT+="0 | Zoom to 100%\n"
OUTPUT+="9 / backspace | Reset Zoom\n"
OUTPUT+="w | Zoom Fit Window Width (crops)\n"
OUTPUT+="Shift+w | Zoom Fit Window Height (crops)\n"
OUTPUT+="z | Zoom Fit Window\n"
OUTPUT+="Shift+z | Zoom Fill Window (crops)\n"
OUTPUT+="r | Reset Cache/Reload Image\n"

# ── Viewer Image Control ──────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► VIEWER MODE | IMAGE CONTROL\n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="o / Space | Next Image\n"
OUTPUT+="u | Previous Image\n"
OUTPUT+="n | Flip Horizontal\n"
OUTPUT+="m | Flip Vertical (Mirror)\n"
OUTPUT+="[ | Flip 90° Clockwise\n"
OUTPUT+="] | Flip 90° Counter-Clockwise\n"

# ── Viewer Utilities ──────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► VIEWER MODE | UTILITIES\n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="f / Tab | Toggle Info Overlay\n"
OUTPUT+="d | Drag and Drop File (ripdrag)\n"
OUTPUT+="c | Copy Image Path\n"
OUTPUT+="e | Execute External Command (stdout)\n"
OUTPUT+="b | Enable/Disable Anti-Aliasing\n"
OUTPUT+="v | Start/Stop Animation\n"
OUTPUT+="F12 | Print API Info (terminal)\n"

# ── Gallery Mode ──────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► GALLERY MODE | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="Return / Space | Switch to Viewer Mode\n"
OUTPUT+="i / Up | Navigate Up\n"
OUTPUT+="k / Down | Navigate Down\n"
OUTPUT+="j / Left | Navigate Left\n"
OUTPUT+="l / Right | Navigate Right\n"
OUTPUT+="Ctrl-p | Print Marked Files\n"

# ── Slideshow Mode ────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► SLIDESHOW MODE | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="Delete | Delete File from Disk\n"

# ── Pipe to Fuzzel ────────────────────────────────────────────────────────────
echo -e "$OUTPUT" | column -t -s '|' | \
    fuzzel --dmenu \
           --lines 25 \
           --width 100 \
           --prompt "   Swayimg Keybinds ❯ "
