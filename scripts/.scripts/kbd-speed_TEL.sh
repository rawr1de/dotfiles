#!/usr/bin/env bash
# kbd-speed.sh — Set keyboard repeat delay and rate
# Works on KDE Plasma 6 / X11 (Manjaro)
#
# DELAY = time before key starts repeating (milliseconds)
# RATE  = how fast it repeats after that (repetitions per second)
#
# Usage:
#   ./kbd-speed.sh              # uses defaults below
#   ./kbd-speed.sh 200 40       # delay=200ms, rate=40/sec

# ── Defaults (edit these to your taste) ────────────────────────────
DELAY=${1:-400}   # ms before repeat starts  (lower = faster response)
RATE=${2:-10}     # repeats per second        (higher = faster repeat)
# ───────────────────────────────────────────────────────────────────

echo "Setting keyboard: delay=${DELAY}ms  rate=${RATE}/sec"

# 1. X11 level — takes effect immediately in current session
xset r rate "$DELAY" "$RATE"

# 2. KDE Plasma level — persists across reboots via kconfig
kwriteconfig6 --file kcminputrc \
              --group Keyboard \
              --key RepeatDelay "$DELAY"

kwriteconfig6 --file kcminputrc \
              --group Keyboard \
              --key RepeatRate "$RATE"

# 3. Notify KDE to reload input settings without restarting
if command -v qdbus6 &>/dev/null; then
    qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
elif command -v qdbus &>/dev/null; then
    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
fi

echo "Done. To verify: xset q | grep 'auto repeat delay'"
