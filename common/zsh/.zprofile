# add to ssh agent the pgp keys based on the machine's hostname
case "$(hostname)" in
    legion)  ssh-add ~/.ssh/id_legion  ;;
    templar) ssh-add ~/.ssh/id_templar ;;
esac

# ─── VISUAL  ─────────────────────

# bigger font in TTY
setfont /usr/share/kbd/consolefonts/latarcyrheb-sun32



# ─── ENVIRONMENT ─────────────────────

# System-wide PATH — ensures all installed binaries are accessible
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/rena/.local/bin


# Auto-launch niri on TTY1 with a proper Wayland session
if [ -z "$DISPLAY" ] && [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    export XDG_RUNTIME_DIR="/run/user/$(id -u)"           # user runtime dir for sockets/pipes
    export XDG_SESSION_TYPE=wayland                       # tell apps we're on Wayland
    export XDG_SESSION_DESKTOP=niri                       # identify the compositor
    export MOZ_ENABLE_WAYLAND=1                           # Firefox native Wayland
    export QT_QPA_PLATFORM=wayland                        # Qt apps use Wayland backend
    export ELECTRON_OZONE_PLATFORM_HINT=wayland           # Electron apps use Wayland backend
    exec dbus-run-session niri                            # start dbus session then niri
fi

# default text editor
export EDITOR="emacsclient -nw"
export VISUAL="emacsclient -c"

# custom paths
PATH=$PATH:~/.config
PATH=$PATH:~/.scripts
PATH=$PATH:~/.scripts/groff_helpers/helpers
PATH=$PATH:~/.scripts/PCs/Legion5/kb_controls/
PATH=$PATH:~/.themes
PATH=$PATH:~/.icons
