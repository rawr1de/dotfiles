```bash
# REPOS FIRST
sudo xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree && sudo xbps-install -S

# THE MASTER LIST (Including Polkit, Drivers, and 32-bit libs for Steam)
sudo xbps-install -y \
nvidia nvidia-libs-32bit \
mesa-dri mesa-dri-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit \
vulkan-loader vulkan-loader-32bit \
linux-firmware-amd linux-firmware-nvidia linux-firmware-network amd-ucode \
libva-utils mesa-vaapi libva-nvidia-driver \
polkit polkit-gnome dbus seatd elogind \
niri xorg-server-xwayland xdg-desktop-portal-gnome kitty

```

---

### 2. Actionable Hardware Config (Early KMS & Dracut)

This section ensures your HDMI and USB-C ports (wired to NVIDIA) work at the moment of boot.

#### Step A: Make it Permanent (The Config)

```bash
sudo mkdir -p /etc/dracut.conf.d
echo 'force_drivers+=" nvidia nvidia_modeset nvidia_uvm nvidia_drm "' | sudo tee /etc/dracut.conf.d/nvidia.conf

```

#### Step B: Enable Wayland Modesetting (The Bootloader)

```bash
# Inject the parameter into GRUB
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 /' /etc/default/grub

# Write the changes to the boot partition
sudo update-grub

```

#### Step C: The Repack (Kernel Reconfiguration)

This is the "action" that applies your new Dracut config to the actual kernel image.

```bash
# This triggers Dracut to rebuild using your nvidia.conf
sudo xbps-reconfigure -f linux$(uname -r | cut -d. -f1,2)

```

---

### 3. Actionable System "Glue" (Runit & Users)

```bash
# 1. Enable background services (NetworkManager handles both your AX200 and r8169)
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/seatd /var/service/
sudo ln -s /etc/sv/NetworkManager /var/service/

# 2. Assign hardware permissions (Including _seatd for Niri)
sudo usermod -aG video,audio,network,_seatd $USER

```

---

### 4. Niri Autostart Prep

In your Niri `config.kdl`, ensure this line is present to avoid permission errors in your graphical session:
`spawn-at-startup "/usr/libexec/polkit-gnome-authentication-agent-1"`

### Condensed Hardware Fact Sheet

* **Internal Screen:** Handled by AMD iGPU (`mesa-dri`).
* **External Ports:** Handled by NVIDIA dGPU (`nvidia`).
* **Early KMS:** Required via `dracut` + `nvidia-drm.modeset=1`.
* **Wi-Fi/Ethernet:** Needs `linux-firmware-network` package.
