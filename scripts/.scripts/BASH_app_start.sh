#!/bin/bash

# ==============================================================================
# Autostart Script for KDE Plasma
# ==============================================================================
# This script launches specified applications when the KDE Plasma session starts.
# It is designed to be added to the Autostart list in System Settings.
#
# Applications launched by this script:
#   - Kitty terminal
#   - Emacs editor
#
# The '&' symbol at the end of each command is crucial. It tells the shell to
# run the command in the background, allowing the script to continue to the
# next line immediately without waiting for the application to close.
# Without this, the script would open Kitty and then stop, never launching Emacs.
#
# A short sleep command is included to prevent any potential race conditions
# on startup, ensuring the applications launch smoothly.
# ==============================================================================

# A brief pause to ensure the desktop environment is fully loaded.
sleep 2

# Launch the Kitty terminal.
# The '&' puts the process in the background.
kitty &

# Launch Emacs.
# The '&' puts the process in the background.
emacs &

# Exit the script.
exit 0
