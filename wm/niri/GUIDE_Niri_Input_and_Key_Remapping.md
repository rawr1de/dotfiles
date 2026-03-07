# Niri Input & Key Remapping: The Full Guide

This guide covers everything for setting up your keyboard in Niri (Wayland), replacing old X11 tools like `xmodmap` and `xset`.

---

## 1. Why X11 Tools Fail
Wayland compositors (Niri) handle input directly via `libinput`. Tools like `xmodmap`, `xset`, and `xev` talk to the X Server, which is not in control here. 

---

## 2. Testing Key Names (The `wev` Utility)
In Wayland, use `wev` to find the "keysym" names of your keys.
1. **Install:** `sudo pacman -S wev`
2. **Run:** Type `wev` in a terminal.
3. **Use:** Press a key and look for the `keysym` string. Use that exact name in your Niri config.

---

## 3. Remapping Caps Lock to Home

### Method 1: The System-Wide Approach (keyd) - RECOMMENDED
Works at the kernel level (Niri, TTY, Login screen).
1. **Install:** `yay -S keyd`
2. **Config (`/etc/keyd/default.conf`):**
   ```ini
   [ids]
   *
   [main]
   capslock = home
   ```
3. **Activate:** `sudo systemctl enable --now keyd`

### Method 3: The Modern Way (xremap)
Uses YAML and is highly flexible within the desktop session.
1. **Install:** `yay -S xremap-niri-bin`
2. **Config (`~/.config/xremap/config.yml`):**
   ```yaml
   modmap:
     - name: Caps to Home
       remap:
         CapsLock: Home
   ```
3. **Autostart:** Add to Niri `config.kdl`:
   `spawn-at-startup "xremap" "--watch" "/home/YOUR_USER/.config/xremap/config.yml"`

---

## 4. Changing Typing Speed (Replacing `xset`)
Niri handles repeat rates natively in its configuration file.

**File:** `~/.config/niri/config.kdl`
```kdl
input {
    keyboard {
        // Delay before repeating (ms)
        repeat-delay 250
        // Characters per second
        repeat-rate 40
    }
}
```

---

## 5. Comparison Summary

| Feature | keyd (Method 1) | xremap (Method 3) | Niri Native |
| :--- | :--- | :--- | :--- |
| **Layer** | Kernel | User/Compositor | Compositor |
| **TTY Support**| Yes | No | No |
| **Repeat Rate**| No (Use Niri) | No (Use Niri) | **Yes** |
| **Complexity** | Simple INI | YAML | KDL |

---
**Verdict:** Use **keyd** for the remap (Caps->Home) and **Niri's config** for the typing speed.


In Wayland, the "clipboard" isn't a single background service like it was in X11. Instead, the compositor (Niri) handles it. If you close an app, the text you copied from it often disappears because the app is no longer there to "serve" that data.

To make copy-paste work reliably and have a history, you need two things: wl-clipboard (the engine) and cliphist (the memory).

1. Install the Essentials
Open your terminal and grab these from the AUR:

Bash
yay -S wl-clipboard cliphist
2. Enable Autostart in Niri
You need to tell Niri to start "watching" your clipboard the moment you log in. Open your ~/.config/niri/config.kdl and add these lines to your spawn-at-startup section:

Code snippet
// This watches the clipboard and saves it to a local database
spawn-at-startup "bash" "-c" "wl-paste --type text --watch cliphist store"
spawn-at-startup "bash" "-c" "wl-paste --type image --watch cliphist store"
3. Bind a "Clipboard Menu" Key
Since you're using Niri, you probably want a quick way to see your history and pick something to paste. Most people bind this to Super + V.

Add this to your binds block in config.kdl:

Code snippet
// Super + V opens a menu (using fuzzel) to pick from your clipboard history
Mod+V { spawn "bash" "-c" "cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"; }
(Note: If you aren't using fuzzel, replace it with rofi -dmenu or wofi --dmenu.)

The "XWayland" Headache
Since you mentioned running X11 apps (like Steam or older editors), you might find that you can't copy from a Wayland app (like Alacritty) and paste into an X11 app.

The Fix: Make sure xwayland-satellite is running. Niri usually handles the bridge, but if it feels "stuck," you can manually force a sync with this command:
wl-paste | xclip -selection clipboard

Summary Table for your Notes:TaskToolNiri ActionBasic Copy/Pastewl-clipboardAutomatic (if app is open)Clipboard Historycliphistspawn-at-startup in configMiddle-Click PastePrimary SelectionEnabled by default in NiriX11 Compatibilityxwayland-satelliteEssential for X11 apps