#!/usr/bin/env bash

WINDOWS=$(niri msg -j windows)

# 1. Fetch the focused window; exit if the workspace is empty
FOCUSED_WINDOW=$(echo "$WINDOWS" | jq -c '.[] | select(.is_focused == true)')
if [[ -z "$FOCUSED_WINDOW" ]]; then
    exit 0
fi

# 2. Extract properties for the current window
IS_FLOATING=$(echo "$FOCUSED_WINDOW" | jq -r '.is_floating')
FOCUSED_ID=$(echo "$FOCUSED_WINDOW" | jq -r '.id')
WORKSPACE_ID=$(echo "$FOCUSED_WINDOW" | jq -r '.workspace_id')
COLUMN_IDX=$(echo "$FOCUSED_WINDOW" | jq -r '.layout.pos_in_scrolling_layout[0]')

# 3. Exit if the window is floating (no column data)
if [[ "$IS_FLOATING" == "true" || "$COLUMN_IDX" == "null" ]]; then
    exit 0
fi

# 4. Gather all window IDs sharing this workspace and column index, sorted vertically
readarray -t WIN_IDS < <(echo "$WINDOWS" | jq -r "[.[] | select(.workspace_id == $WORKSPACE_ID and .layout.pos_in_scrolling_layout[0] == $COLUMN_IDX)] | sort_by(.layout.pos_in_scrolling_layout[1]) | .[] | .id")

LEN=${#WIN_IDS[@]}

# 5. Exit if there is only 1 window (nothing to cycle)
if (( LEN <= 1 )); then
    exit 0
fi

# 6. Cycle to the next window, wrapping around at the bottom
for i in "${!WIN_IDS[@]}"; do
    if [[ "${WIN_IDS[$i]}" == "$FOCUSED_ID" ]]; then
        NEXT_IDX=$(( (i + 1) % LEN ))
        niri msg action focus-window --id "${WIN_IDS[$NEXT_IDX]}"
        break
    fi
done
