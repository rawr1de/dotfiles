#!/bin/bash

# --- REQUIREMENTS CHECK ---
# Ensure wmctrl is installed to manage window placement and state.
if ! command -v wmctrl &> /dev/null
then
    echo "Error: 'wmctrl' is required for monitor and maximization control but is not installed." >&2
    echo "Please install it (e.g., 'sudo apt install wmctrl' or 'sudo dnf install wmctrl')." >&2
    exit 1
fi

# --- CONFIGURATION SETUP ---

TEMP_DIR=$(mktemp -d)
CONFIG_FILE="${TEMP_DIR}/tmatrix_config"

cat <<EOF > "$CONFIG_FILE"
background_opacity 1.0
hide_window_decorations yes
window_border_width 0
enable_csi_u_mode yes
EOF

trap "rm -f \"$CONFIG_FILE\"; rmdir \"$TEMP_DIR\"" EXIT

# --- LAUNCH AND WINDOW MANIPULATION ---

YELLOW_TITLE="Tmatrix-Yellow-Window"
BLACK_TITLE="Tmatrix-Black-Window"

echo "Launching Tmatrix terminals..."

# Terminal 1: Yellow Tmatrix (Target Monitor 1: DP-0)
kitty --title "$YELLOW_TITLE" --config "$CONFIG_FILE" sh -c 'tmatrix -C yellow' &
YELLOW_PID=$!

# Terminal 2: Black Tmatrix (Target Monitor 2: HDMI-0)
kitty --title "$BLACK_TITLE" --config "$CONFIG_FILE" sh -c 'tmatrix -C black' &
BLACK_PID=$!

# Give the window manager an initial moment to create the windows
sleep 0.5

# --- NEW: FUNCTION TO WAIT FOR WINDOW AND APPLY WMCTRL ---

# Arguments: $1 = Window Title, $2 = Target Monitor Index
apply_wmctrl() {
    local TITLE="$1"
    local MONITOR_INDEX="$2"
    local MAX_ATTEMPTS=10
    local ATTEMPT=0
    
    echo "Attempting to locate and place window: $TITLE on Monitor $MONITOR_INDEX..."

    # Loop until the window is found by wmctrl or max attempts reached
    while [[ $ATTEMPT -lt $MAX_ATTEMPTS ]]; do
        # Search for the window ID by title
        if wmctrl -l | grep -q "$TITLE"; then
            echo "Window found. Applying maximization and moving to Monitor $MONITOR_INDEX."
            
            # Apply maximization and move to viewport (monitor)
            wmctrl -r "$TITLE" -b add,maximized_vert,maximized_horz
            wmctrl -r "$TITLE" -t "$MONITOR_INDEX"
            
            # Add a small stabilization delay after WM manipulation
            sleep 0.2
            return 0 # Success
        fi
        
        ATTEMPT=$((ATTEMPT + 1))
        sleep 0.5 # Wait and try again
    done

    echo "Error: Failed to find window '$TITLE' after $MAX_ATTEMPTS attempts. Check 'wmctrl -l' output." >&2
    return 1 # Failure
}

# Apply the wmctrl logic robustly
apply_wmctrl "$YELLOW_TITLE" 0
apply_wmctrl "$BLACK_TITLE" 1

# Wait for both kitty processes to finish (i.e., when the user closes them)
wait "$YELLOW_PID" "$BLACK_PID"

echo "Tmatrix terminals closed. Cleanup complete."
