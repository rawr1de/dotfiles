### 1. The Blueprint: Essential Packages & Logic

This list bridges your specific AMD/NVIDIA hybrid hardware with the Niri/Wayland stack.

| Category | Packages (xbps names) | Purpose |
| --- | --- | --- |
| **Repos** | `void-repo-nonfree`, `void-repo-multilib`, `void-repo-multilib-nonfree` | Unlocks NVIDIA drivers and Steam. |
| **NVIDIA** | `nvidia`, `nvidia-libs-32bit` | Proprietary drivers and 32-bit gaming support. |
| **AMD** | `mesa-dri`, `mesa-dri-32bit`, `mesa-vulkan-radeon`, `mesa-vulkan-radeon-32bit` | iGPU drivers and Vulkan support. |
| **Firmware** | `linux-firmware-amd`, `amd-ucode`, `linux-firmware-nvidia` | Hardware-level blobs for GPU/CPU stability. |
| **System** | `dbus`, `seatd`, `elogind`, `polkit-gnome` | Hardware access, session, and power management. |
| **Display** | `niri`, `xorg-server-xwayland`, `xdg-desktop-portal-gnome` | The WM and the bridge for screen sharing/X11 apps. |

---

### 2. Actionable Steps: Installation & Config

Perform these steps in order once you have booted the **Base glibc ISO** and logged in as `anon`.

#### Step A: Enable Repositories

```bash
sudo xbps-install -S void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree
sudo xbps-install -S

```

#### Step B: Install the Graphics & System Stack

```bash
sudo xbps-install -S nvidia nvidia-libs-32bit mesa-dri mesa-dri-32bit mesa-vulkan-radeon mesa-vulkan-radeon-32bit vulkan-loader vulkan-loader-32bit linux-firmware-amd amd-ucode linux-firmware-nvidia dbus seatd elogind polkit-gnome niri xorg-server-xwayland xdg-desktop-portal-gnome

```

#### Step C: Configure Kernel & User

1. **Enable NVIDIA Modesetting:**
* Open the file: `sudo nano /etc/default/grub`.
* Edit the line: `GRUB_CMDLINE_LINUX_DEFAULT="... nvidia-drm.modeset=1"`.
* Update bootloader: `sudo update-grub`.


2. **Set Permissions:**
* `sudo usermod -aG video,audio,_seatd your_username`.



#### Step D: Initialize Services

Enable the background processes required to start Niri successfully.

```bash
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/seatd /var/service/
sudo ln -s /etc/sv/NetworkManager /var/service/

```

### 3. Verification

Reboot the machine. Log in and verify the kernel parameter:
`cat /sys/module/nvidia_drm/parameters/modeset`
If it returns **Y**, you are ready to type `niri` and enter your workspace.

---

**Everything is now installed and configured.** Would you like to proceed with the dual-monitor `output` configuration for your Niri `config.kdl`?
