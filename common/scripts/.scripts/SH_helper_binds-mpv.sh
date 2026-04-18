#!/usr/bin/env bash

OUTPUT=""

# ── Playback & Seeking ────────────────────────────────────────────────────────
OUTPUT+="► PLAYBACK & SEEKING | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="Space / p | Pause / Play\n"
OUTPUT+="Left / Right | Seek Backward/Forward 5 seconds\n"
OUTPUT+="Up / Down | Seek Backward/Forward 1 minute\n"
OUTPUT+="Shift+Left / Right | Exact Seek 1 second (don't snap to keyframes)\n"
OUTPUT+="Shift+Up / Down | Exact Seek 5 seconds\n"
OUTPUT+=". | Step Forward 1 frame\n"
OUTPUT+=", | Step Backward 1 frame\n"
OUTPUT+="Backspace | Reset playback speed to normal\n"

# ── Speed Control ─────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► SPEED CONTROL | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="[ | Decrease speed by 10%\n"
OUTPUT+="] | Increase speed by 10%\n"
OUTPUT+="{ | Half speed (Decrease by 50%)\n"
OUTPUT+="} | Double speed (Increase by 50%)\n"

# ── Audio Controls ────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► AUDIO CONTROLS | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="9 / / | Decrease Volume\n"
OUTPUT+="0 / * | Increase Volume\n"
OUTPUT+="m | Mute Audio\n"
OUTPUT+="# | Cycle through Audio Tracks\n"
OUTPUT+="+ / - | Adjust Audio Delay (A/V sync)\n"

# ── Video & Window ────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► VIDEO & WINDOW | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="f | Toggle Fullscreen\n"
OUTPUT+="T | Toggle Stay-on-Top\n"
OUTPUT+="w / W | Pan Video (Zoomed in)\n"
OUTPUT+="Alt+0 | Resize window to half size\n"
OUTPUT+="Alt+1 | Resize window to original size\n"
OUTPUT+="Alt+2 | Resize window to double size\n"
OUTPUT+="1 / 2 | Decrease / Increase Contrast\n"
OUTPUT+="3 / 4 | Decrease / Increase Brightness\n"
OUTPUT+="5 / 6 | Decrease / Increase Gamma\n"
OUTPUT+="7 / 8 | Decrease / Increase Saturation\n"

# ── Subtitles ─────────────────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► SUBTITLES | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="v | Toggle Subtitle Visibility\n"
OUTPUT+="j / J | Cycle Next / Previous Subtitle Track\n"
OUTPUT+="z / Z | Adjust Subtitle Delay (Sync)\n"
OUTPUT+="r / R | Move Subtitles Up / Down\n"

# ── Playlist & Utilities ──────────────────────────────────────────────────────
OUTPUT+="\n | \n"
OUTPUT+="► PLAYLIST & UTILITIES | \n"
OUTPUT+="══════════════════════ | ══════════════════════\n"
OUTPUT+="< | Previous file in playlist\n"
OUTPUT+="> / Enter | Next file in playlist\n"
OUTPUT+="i | Show File Info / Stats (Hold)\n"
OUTPUT+="I | Toggle File Info / Stats (Persistent)\n"
OUTPUT+="O | Toggle OSD (On-Screen Display) states\n"
OUTPUT+="s | Take Screenshot (with subtitles)\n"
OUTPUT+="S | Take Screenshot (without subtitles)\n"
OUTPUT+="Ctrl+s | Take Screenshot of the whole window\n"
OUTPUT+="q / Esc | Quit\n"
OUTPUT+="Q | Quit and save position (Watch Later)\n"

# ── Pipe to Fuzzel ────────────────────────────────────────────────────────────
echo -e "$OUTPUT" | column -t -s '|' | \
    fuzzel --dmenu \
           --lines 25 \
           --width 100 \
           --prompt "   MPV Keybinds ❯ "
