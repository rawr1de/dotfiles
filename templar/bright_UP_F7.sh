#!/usr/bin/bash
#brightnessctl set +10%
#VALUE=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')
#notify-send -i brightness-high "Brightness" "" -h int:value:"$VALUE" -h string:x-canonical-private-synchronous:brightness
brightnessctl set +10%
VALUE=$(brightnessctl -m | awk -F, '{print $4}' | tr -d '%')

gdbus call --session \
  --dest org.freedesktop.Notifications \
  --object-path /org/freedesktop/Notifications \
  --method org.freedesktop.Notifications.Notify \
  "brightness" 99 "brightness-high" "Brightness" "" [] \
  "{'value': <$VALUE>}" 2000
