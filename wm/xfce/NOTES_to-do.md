# XFCE

---

## ⚠ TODO — Pending Integration

### 1. Add `scripts/` folder to this directory

The following script needs to be placed at `wm/xfce/scripts/SH_rename_xdg_dirs.sh`:

- **What it does:** Reads `~/.config/user-dirs.dirs` and renames the standard XDG home directories (`Music`, `Pictures`, `Downloads`, etc.) to the custom short names defined in that file (e.g. `Music` → `Musk`, `Pictures` → `Pix`).
- **Why it's here and not in `common/scripts`:** It is XFCE-specific. On other WMs this is handled differently or not needed.
- The script already exists — retrieve it by asking:
  > *"Give me the SH_rename_xdg_dirs.sh script we built, with XDG_PUBLICSHARE_DIR and XDG_TEMPLATES_DIR removed"*

---

### 2. Add `xfce4-desktop.xml` to this directory

Place the xfconf desktop config at `wm/xfce/xfce4-desktop.xml` and have the deploy script copy it to:
```
~/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml
```

The key setting it must contain is:
```xml
<property name="icon-style" type="int" value="0"/>
```
This disables all icons on the XFCE desktop (no home folder, no drives, nothing).

Alternatively, instead of a config file, use this command in the deploy script:
```bash
xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0 --create -t int
xfdesktop --reload
```
> ⚠ Must run after first XFCE login — xfconfd needs to be running.

---

### 3. Hook both into `deploy_v4.sh`

Inside the existing XFCE profile detection block, add:

```bash
if [ "$WM" = "xfce" ]; then
    bash wm/xfce/scripts/SH_rename_xdg_dirs.sh
    xfconf-query -c xfce4-desktop -p /desktop-icons/style -s 0 --create -t int
fi
```

---

### Expected final structure

```
wm/xfce/
├── README.md
└── xfce4-desktop.xml
```