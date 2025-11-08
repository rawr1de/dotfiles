#!/bin/bash
pamixer --allow-boost -i 5; pamixer --get-volume-human | xargs -I {} notify-send "Volume: {}"
