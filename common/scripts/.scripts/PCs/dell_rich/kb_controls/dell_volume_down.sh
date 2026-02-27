#!/bin/bash
pamixer --allow-boost -d 5; pamixer --get-volume-human | xargs -I {} notify-send "Volume: {}"
