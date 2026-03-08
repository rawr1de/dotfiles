#!/bin/bash

# 1. Fix Keyring and Update (Crucial for fresh ISOs)
echo "Fixing GPG keyrings..."
sudo pacman -Sy archlinux-keyring manjaro-keyring --noconfirm
sudo pacman-key --init && sudo pacman-key --populate archlinux manjaro

# 2. Bootstrap Yay (AUR Helper)
# Manjaro includes 'base-devel' by default, but we ensure it's there.
echo "Installing Yay..."
sudo pacman -S --needed base-devel git --noconfirm
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay && makepkg -si --noconfirm
cd -

# 3. Purge Xfce4 Surgically
echo "Removing Xfce4 and LightDM..."
sudo pacman -Rns xfce4 xfce4-goodies manjaro-xfce-minimal-settings lightdm --noconfirm

# 4. Install Niri and Portals via Yay
echo "Installing Niri from AUR..."
yay -S niri-git xdg-desktop-portal-gnome polkit-gnome --noconfirm

# 5. Enable TTY1 Autologin
echo "Configuring TTY1 autologin..."
CONF_DIR="/etc/systemd/system/getty@tty1.service.d"
sudo mkdir -p "$CONF_DIR"
cat <<EOF | sudo tee "$CONF_DIR/override.conf"
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM
EOF

# 6. Generate .zprofile
echo "Configuring .zprofile..."
cat <<EOF > ~/.zprofile
# --- Common Environment ---
export EDITOR="emacsclient -c"
export VISUAL="emacsclient -c"

# --- Machine-Specific Hardware Logic ---
if [[ "\$(hostname)" == "legion" ]]; then
    export GBM_BACKEND=nvidia-drm
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export LIBVA_DRIVER_NAME=nvidia
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM="wayland;xcb"
else
    export MOZ_ENABLE_WAYLAND=1
    export QT_QPA_PLATFORM="wayland;xcb"
fi

# --- TTY1 Autostart ---
if [[ -z \$DISPLAY && \$(tty) == /dev/tty1 ]]; then
    export XDG_CURRENT_DESKTOP=niri
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=niri
    exec niri-session
fi
EOF

# 7. Conditional NVIDIA Modesetting (Legion Only)
if [[ "$(hostname)" == "legion" ]]; then
    if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 /' /etc/default/grub
        sudo update-grub
    fi
fi

# 8. Final Orphan Cleanup
echo "Cleaning up..."
sudo pacman -Rns \$(pacman -Qdtq) --noconfirm

echo "Done. Reboot to start Niri."
