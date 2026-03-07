# Wayland Key Remapping: The Full Guide (xmodmap is Dead)

In X11 (XFCE), `xmodmap` worked by talking to the X Server. In Wayland (Niri), the compositor (Niri) and the kernel (libinput) handle keys directly. Your old `.xmodmap` files are invisible to Niri.

---

##  How to Find Key Names in Wayland
Since you can't use `xev` reliably, use **wev**.
1. **Install:** `sudo pacman -S wev`
2. **Run:** Type `wev` in a terminal and press a key.
3. **Look for:** The `keysym` name (e.g., `XF86AudioRaiseVolume`). Use this exact string in your Niri config.

---

##  Method 1: The System-Wide Approach (keyd)
**Recommended.** This works at the kernel level. Your remap works in Niri, the TTY console, and even other Desktop Environments.

### 1. Installation
```bash
yay -S keyd
```

### 2. Configuration (`/etc/keyd/default.conf`)
```ini
[ids]
*

[main]
# Remap Caps Lock to Home
capslock = home
```

### 3. Activation
```bash
sudo systemctl enable --now keyd
```

---

## Method 2: The Native Way (XKB Options)
Niri uses XKB. While XKB has presets for Caps (like `caps:escape` or `caps:backspace`), it does **not** have a default for `caps:home`. To do this natively, you would have to write custom XKB symbols, which is unnecessarily complex compared to the other methods.

---

## Method 3: The Modern Way (xremap)
**Highly Flexible.** Use the version specifically built for Niri.

### 1. Installation
```bash
yay -S xremap-niri-bin
```

### 2. Configuration (`~/.config/xremap/config.yml`)
```yaml
modmap:
  - name: Caps to Home
    remap:
      CapsLock: Home
```

### 3. Autostart (Niri `config.kdl`)
Add this line to your `binds` or `spawn-at-startup` section:
```kdl
spawn-at-startup "xremap" "--watch" "/home/YOUR_USERNAME/.config/xremap/config.yml"
```

---

## Comparison Summary

| Feature | keyd (Method 1) | xremap (Method 3) |
| :--- | :--- | :--- |
| **Layer** | Kernel (Universal) | User (Compositor) |
| **Works in TTY?** | Yes | No |
| **Complex Logic** | Supports layers/taps | Superior YAML flexibility |
| **Reliability** | Highest (Set & Forget) | High (Requires Autostart) |

---
**Verdict:** Start with **keyd**. It solves the problem once for the whole system.
