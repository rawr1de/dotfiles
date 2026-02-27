#!/bin/bash

# list all man pages with rofi and print selected page in a pdf file and delete after pdf closure

man -k . | rofi -dmenu -l 20 | awk '{print $1}' | xargs -I {} man -Tpdf {} > man.pdf && zathura man.pdf && rm -rf man.pdf 
