#!/bin/bash

# This script launches two Kitty terminals running 'tmatrix'
# It creates a temporary configuration file to ensure the terminals are
# borderless and do not show a PS1 prompt.

# Create a temporary directory and a configuration file within it.
# The 'mktemp -d' command is a standard way to create a secure temporary directory.
# This prevents potential conflicts with other scripts or users.
TEMP_DIR=$(mktemp -d)
CONFIG_FILE="${TEMP_DIR}/tmatrix_config"

# Use a here document to write the configuration to the temporary file.
# This is much cleaner than using multiple echo commands.
cat <<EOF > "$CONFIG_FILE"
background_opacity 1.0
hide_window_decorations yes
window_border_width 0
enable_csi_u_mode yes
EOF

# Terminal 1: Yellow Tmatrix
# We now use the '--config' flag to point to the temporary config file.
# This is a more widely supported flag than '--config-file'.
kitty --title "Tmatrix Yellow" --config "$CONFIG_FILE" sh -c 'tmatrix -C yellow' &

# Terminal 2: Black Tmatrix
kitty --title "Tmatrix Black" --config "$CONFIG_FILE" sh -c 'tmatrix -C black' &

# The 'wait' command ensures the script doesn't exit immediately, allowing
# the launched kitty processes to use the temporary file.
wait

# Clean up the temporary file and directory when the script finishes.
# The 'rm' command deletes the file, and 'rmdir' deletes the directory.
# The 'trap' command ensures this cleanup happens even if the script is
# interrupted, for example, with Ctrl+C.
trap "rm -f \"$CONFIG_FILE\"; rmdir \"$TEMP_DIR\"" EXIT

echo "Tmatrix terminals launched. You can close this window now."
