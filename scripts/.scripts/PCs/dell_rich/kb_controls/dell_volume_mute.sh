#!/bin/bash
pamixer -t; pamixer --get-mute | xargs -I {} notify-send "Mudo?  {}"
