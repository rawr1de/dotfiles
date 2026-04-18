#!/usr/bin/env bash

BIND_FILE="$HOME/.config/niri/binds.kdl"
OUTPUT=""

# ── 1. Manual Overrides ───────────────────────────────────────────────────────
OUTPUT+="KEYS ACTIONS| DESCRIPION\n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="Mod + i,j,k,l          | Window/Column Navigation\n"
OUTPUT+="Mod+Ctrl               | Focus Workspace Modifier\n"
OUTPUT+="Mod+Alt                | Move Monitor Modifier\n"
OUTPUT+="Mod+Shift              | Switch Modifier\n"
OUTPUT+="Mod+Ctrl+Alt           | Move Column to Monitor\n"
OUTPUT+="Mod+Ctrl + 1,2,3..     | Send Column to Workspace\n"
OUTPUT+="Mod+Shift+/            | Helper\n"

# ── 2. Parse Niri Config Sequentially ─────────────────────────────────────────
if [[ -f "$BIND_FILE" ]]; then
    while read -r line; do

        # A. Detect Headers: Matches // NAME followed by // ───
        if [[ "$line" =~ ^[[:space:]]*//[[:space:]]*([A-Z]{2,}.*) ]]; then
            header="${BASH_REMATCH[1]}"
            OUTPUT+="\n | \n"
            OUTPUT+="► ${header} | \n"
            OUTPUT+="══════════════════════ | ══════════════════════\n"
            continue
        fi

        # B. Skip all other comments
        if [[ "$line" =~ ^[[:space:]]*(//|/-|#) ]]; then
            continue
        fi

        # C. Parse actual binds with hotkey-overlay-title
        if [[ "$line" =~ ^[[:space:]]*([^[:space:]]+).+hotkey-overlay-title=\"([^\"]+)\" ]]; then
            key="${BASH_REMATCH[1]}"
            description="${BASH_REMATCH[2]}"

            OUTPUT+="${key} | ${description}\n"
        fi

    done < "$BIND_FILE"
else
    OUTPUT+="Error | Could not find $BIND_FILE\n"
fi

# ── 3. Pipe to Fuzzel ─────────────────────────────────────────────────────────
echo -e "$OUTPUT" | column -t -s '|' | \
    fuzzel --dmenu \
           --lines 25 \
           --width 100 \
           --prompt ". Niri Keybinds ❯ "
