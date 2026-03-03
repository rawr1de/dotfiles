#!/bin/bash

# list all man pages with rofi and print selected page in a pdf file and delete after pdf closure
# run  sudo mandb  to create the man data base for the first time

selection=$(man -k . | rofi -dmenu -l 20 | awk '{print $1}')

[ -z "$selection" ] && exit 0

man -Tpdf "$selection" > man.pdf && zathura man.pdf && rm -rf man.pdf
