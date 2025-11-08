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

# Create a secure temporary directory and a configuration file within it.
TEMP_DIR=$(mktemp -d)
CONFIG_FILE="${TEMP_DIR}/tmatrix_config"

# Use a here document to write the configuration.
# Note: window geometry/state is handled by wmctrl, not this config.
cat <<EOF > "$CONFIG_FILE"
background_opacity 1.0
hide_window_decorations yes
window_border_width 0
enable_csi_u_mode yes
EOF

# Function to ensure cleanup happens even if the script is interrupted.
trap "rm -f \"$CONFIG_FILE\"; rmdir \"$TEMP_DIR\"" EXIT

# --- LAUNCH AND WINDOW MANIPULATION ---

# Define unique titles for reliable identification
YELLOW_TITLE="Tmatrix-Yellow-Window"
BLACK_TITLE="Tmatrix-Black-Window"

# Terminal 1: Yellow Tmatrix (Target Monitor 1: DP-0)
kitty --title "$YELLOW_TITLE" --config "$CONFIG_FILE" sh -c 'tmatrix -C yellow' &
YELLOW_PID=$! # Capture the PID of the last background command

# Terminal 2: Black Tmatrix (Target Monitor 2: HDMI-0)
kitty --title "$BLACK_TITLE" --config "$CONFIG_FILE" sh -c 'tmatrix -C black' &
BLACK_PID=$! # Capture the PID of the last background command

# Give the window manager a brief moment to create the windows.
sleep 1.0

# --- WMCTRL WINDOW PLACEMENT LOGIC ---

# Placement details (these assume standard monitor indexing by wmctrl/your WM)
# Monitor index '1' usually refers to the *second* monitor.
# Check your specific wmctrl -d output if the indices are incorrect.

# Maximize and move Yellow Tmatrix window to Monitor 0 (usually DP-0)
# -r: target by window title regex
# -b add,maximized_vert,maximized_horz: maximize in both directions
# -t 0: move to viewport (monitor) 0
wmctrl -r "$YELLOW_TITLE" -b add,maximized_vert,maximized_horz -t 0

# Maximize and move Black Tmatrix window to Monitor 1 (usually HDMI-0)
wmctrl -r "$BLACK_TITLE" -b add,maximized_vert,maximized_horz -t 1

# Wait for both kitty processes to finish (i.e., when the user closes them)
wait "$YELLOW_PID" "$BLACK_PID"

echo "Tmatrix terminals closed. Cleanup complete."
