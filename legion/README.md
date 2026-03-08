# Legion specific configs

## After Manjaro i3 install, reboot, access any TTY:
```
  legion_i3-niri_clean_install.sh
```

## Niri Legion dual monitor & emacs window rules:
Place the file in:
```
  ~/.config/niri/legion_niri.kdl
```

Add to your main config **~/.config/niri/config.kdl**
```
  include "legion_niri.kdl"
```

## Niri output wrong monitor connectors:
```
niri msg outputs
```
verify if connector is eDP-1 / HDMI-A-1 and update config.kdl accordingly


## If Realtek (RTL8852BE) drops after kernel update:
```
  yay -S rtw89-dkms-git
``` 