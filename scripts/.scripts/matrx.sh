#!/bin/bash

# --- REQUIREMENTS CHECK (Now requires BOTH wmctrl and xdotool) ---
if ! command -v xdotool &> /dev/null || ! command -v wmctrl &> /dev/null
then
    echo "Error: Both 'xdotool' and 'wmctrl' are required for this advanced window manipulation." >&2
    echo "Please ensure both are installed (e.g., 'sudo apt install xdotool wmctrl')." >&2
    exit 1
fi

# ----------------------------------------------------------------------
# --- WINDOW GEOMETRY CONFIGURATION (Confirmed 2560x1440) ---
# ----------------------------------------------------------------------
MONITOR_WIDTH=2560   
MONITOR_HEIGHT=1440  
HDMI_START_X_COORD=2560 
# ----------------------------------------------------------------------


# --- CONFIGURATION SETUP (Remains the same) ---
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

# Terminal 1: Yellow Tmatrix (Target DP-0)
kitty --title "$YELLOW_TITLE" --config "$CONFIG_FILE" sh -c 'tmatrix -C yellow' &
YELLOW_PID=$!

# Terminal 2: Black Tmatrix (Target HDMI-0)
kitty --title "$BLACK_TITLE" --config "$CONFIG_FILE" sh -c 'tmatrix -C black' &
BLACK_PID=$!

# Extended sleep time to ensure windows are created
sleep 2.0

# --- FUNCTION TO APPLY EXPLICIT PLACEMENT (xdotool) ---
# Arguments: $1 = Window Title, $2 = X-Coord, $3 = Y-Coord
move_and_resize() {
    local TITLE="$1"
    local X_COORD="$2"
    local Y_COORD="$3"
    local W="$MONITOR_WIDTH"
    local H="$MONITOR_HEIGHT"
    local MAX_ATTEMPTS=10
    local ATTEMPT=0
    
    echo "Attempting to locate and place window: $TITLE at ($X_COORD, $Y_COORD)..."

    while [[ $ATTEMPT -lt $MAX_ATTEMPTS ]]; do
        WID=$(xdotool search --name "$TITLE" 2>/dev/null)
        
        if [[ -n "$WID" ]]; then
            echo "Window found (WID: $WID)."

            # --- CRITICAL FIX 1: Remove Maximization Hint before moving the window ---
            # This prevents the WM from thinking it needs to be maximized across all screens.
            wmctrl -ir "$WID" -b remove,maximized_vert,maximized_horz
            sleep 0.2

            # --- CRITICAL FIX 2: Double-Apply commands for stability ---
            # 1. First Pass: Move and Resize
            xdotool windowmove "$WID" "$X_COORD" "$Y_COORD"
            xdotool windowsize "$WID" "$W" "$H"
            sleep 0.5 
            
            # 2. Second Pass: Re-apply to enforce geometry
            xdotool windowmove "$WID" "$X_COORD" "$Y_COORD"
            xdotool windowsize "$WID" "$W" "$H"
            
            xdotool windowactivate "$WID"
            
            return 0
        fi
        
        ATTEMPT=$((ATTEMPT + 1))
        sleep 0.5
    done

    echo "Error: Failed to find window '$TITLE' after $MAX_ATTEMPTS attempts." >&2
    return 1
}

# 1. Place Yellow Tmatrix on DP-0 (Monitor 1: starts at X=0)
move_and_resize "$YELLOW_TITLE" 0 0

# 2. Place Black Tmatrix on HDMI-0 (Monitor 2: starts at X=2560)
# The key is removing the maximized state before issuing the windowmove.
move_and_resize "$BLACK_TITLE" "$HDMI_START_X_COORD" 0

# Wait for both kitty processes to finish
wait "$YELLOW_PID" "$BLACK_PID"

echo "Tmatrix terminals closed. Cleanup complete."
