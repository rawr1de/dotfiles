#!/usr/bin/env bash

EMACS_INIT="/home/rdo/.dotfiles/common/emacs.d/"

# 1. Spawn Left Monitor Apps
kitty --class "kitty-left" &
sleep 0.5 

emacsclient -c -F '((name . "emacs-left"))' -a "emacs --init-directory=$EMACS_INIT" &
sleep 0.5 

# 2. Spawn Right Monitor Apps
firefox --new-window --name "firefox-right" &
sleep 1.0 

emacsclient -c -F '((name . "emacs-right"))' -a "emacs --init-directory=$EMACS_INIT" &
