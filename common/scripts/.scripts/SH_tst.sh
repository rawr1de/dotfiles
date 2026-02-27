#!/bin/bash

# sudo sysctl -w dev.tty.legacy_tiocsti=1

# wait for DE is fully loaded
sleep 3

# Run unclutter command
unclutter &

# Run emacsclient then open agenda file
emacsclient -c --eval "(dashboard-refresh-buffer)" &

# Run Kitty with session file ses_1 (opens ranger & CMus)
kitty --session ~/.config/kitty/ses0 &

# One second wait til Brave fires up
sleep 1

# Run Brave at virtual desktop 2
brave &

# disown -h

# Force close the terminal window
#kill -9 $PPID

# Exit the script
exit 0
