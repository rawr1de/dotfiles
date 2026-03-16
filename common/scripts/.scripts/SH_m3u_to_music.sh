#!/bin/bash

# CONV_m3u_plist_music.sh
# Converts audio files listed in an m3u playlist to a target format.
# Interactive — uses fzf to select format and quality.
#
# Flags (optional, skip interactive):
#   -i <file>     Input m3u file       (default: ~/tmp/rdo_list.m3u)
#   -r <dir>      Music root dir       (default: ~/Musk)
#   -f <format>   Output format        (mpc | mp3 | ogg | opus | flac)
#   -q <quality>  Quality profile
#                 mpc:  extreme | high | standard | transparent
#                 mp3:  high (V0) | standard (V2) | small (128k)
#                 ogg:  high (q8) | standard (q5) | small (q3)
#                 opus: high (192k) | standard (128k) | small (64k)
#                 flac: (lossless, quality flag ignored)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
M3U_FILE="$HOME/tmp/rdo_list.m3u"
MUSIC_ROOT="$HOME/Musk"
FORMAT=""
QUALITY=""

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
while getopts "i:r:f:q:" opt; do
    case "$opt" in
        i) M3U_FILE="$OPTARG" ;;
        r) MUSIC_ROOT="$OPTARG" ;;
        f) FORMAT="$OPTARG" ;;
        q) QUALITY="$OPTARG" ;;
        *) echo "Usage: $(basename "$0") [-i m3u] [-r music_root] [-f format] [-q quality]"; exit 1 ;;
    esac
done

# ---------------------------------------------------------------------------
# Header
# ---------------------------------------------------------------------------
echo -e "${BLUE}${BOLD}=== CONV_m3u_plist_music.sh ===${NC}\n"

# ---------------------------------------------------------------------------
# Preflight checks
# ---------------------------------------------------------------------------
if ! command -v fzf &>/dev/null; then
    echo -e "${RED}fzf not found.${NC}"
    exit 1
fi

if [ ! -f "$M3U_FILE" ]; then
    echo -e "${RED}✗ m3u file not found: $M3U_FILE${NC}"
    echo -e "${YELLOW}  Provide one with: -i /path/to/file.m3u${NC}\n"
    exit 1
fi

if [ ! -d "$MUSIC_ROOT" ]; then
    echo -e "${RED}✗ Music root not found: $MUSIC_ROOT${NC}"
    echo -e "${YELLOW}  Provide one with: -r /path/to/dir${NC}\n"
    exit 1
fi

# Count tracks in playlist
TRACK_COUNT=$(grep -v '^\s*#' "$M3U_FILE" | grep -v '^\s*$' | wc -l)

# ---------------------------------------------------------------------------
# Interactive format picker
# ---------------------------------------------------------------------------
if [ -z "$FORMAT" ]; then
    FORMAT=$(printf 'mpc\nmp3\nogg\nopus\nflac' | \
        fzf --prompt="Format > " \
            --header="Select output format" \
            --color 'header:yellow,prompt:cyan,pointer:cyan')
    [ -z "$FORMAT" ] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }
fi

# ---------------------------------------------------------------------------
# Interactive quality picker (per format)
# ---------------------------------------------------------------------------
if [ -z "$QUALITY" ] && [ "$FORMAT" != "flac" ]; then
    case "$FORMAT" in
        mpc)  QUALITY_OPTS="extreme\nhigh\nstandard\ntransparent" ;;
        mp3)  QUALITY_OPTS="high — V0 (~245kbps)\nstandard — V2 (~190kbps)\nsmall — 128kbps CBR" ;;
        ogg)  QUALITY_OPTS="high — q8\nstandard — q5\nsmall — q3" ;;
        opus) QUALITY_OPTS="high — 192kbps\nstandard — 128kbps\nsmall — 64kbps" ;;
    esac

    QUALITY_SEL=$(printf "$QUALITY_OPTS" | \
        fzf --prompt="Quality > " \
            --header="Select quality profile for $FORMAT" \
            --color 'header:yellow,prompt:cyan,pointer:cyan')
    [ -z "$QUALITY_SEL" ] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }

    # Extract just the first word as the quality key
    QUALITY=$(echo "$QUALITY_SEL" | awk '{print $1}')
elif [ "$FORMAT" = "flac" ]; then
    QUALITY="lossless"
fi

# ---------------------------------------------------------------------------
# Check encoder
# ---------------------------------------------------------------------------
case "$FORMAT" in
    mpc)  ENC="mpcenc" ;;
    mp3)  ENC="lame" ;;
    ogg)  ENC="oggenc" ;;
    opus) ENC="opusenc" ;;
    flac) ENC="flac" ;;
esac

if ! command -v "$ENC" &>/dev/null; then
    echo -e "${RED}✗ Encoder not found: $ENC${NC}"
    exit 1
fi

# ---------------------------------------------------------------------------
# Preview + confirm
# ---------------------------------------------------------------------------
echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  Conversion summary${NC}"
echo -e "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
echo -e "  ${YELLOW}Playlist  :${NC} $M3U_FILE"
echo -e "  ${YELLOW}Tracks    :${NC} $TRACK_COUNT"
echo -e "  ${YELLOW}Music root:${NC} $MUSIC_ROOT"
echo -e "  ${YELLOW}Format    :${NC} $FORMAT"
echo -e "  ${YELLOW}Quality   :${NC} $QUALITY"
echo -e "  ${YELLOW}Encoder   :${NC} $ENC"
echo -e "  ${YELLOW}Output    :${NC} alongside source files in <source_dir>/${FORMAT}_enc/\n"

read -rp "Proceed? [y/N]: " confirm
[[ "${confirm,,}" != "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }
echo ""

# ---------------------------------------------------------------------------
# Encode function
# ---------------------------------------------------------------------------
encode_file() {
    local src="$1"
    local dest_dir="$2"
    local base="$3"
    local dest="$dest_dir/$base.$FORMAT"

    mkdir -p "$dest_dir"

    case "$FORMAT" in
        mpc)
            case "$QUALITY" in
                extreme)     Q="--extreme" ;;
                standard)    Q="--standard" ;;
                transparent) Q="--insane" ;;
                *)           Q="--high" ;;
            esac
            mpcenc $Q "$src" "$dest"
            ;;
        mp3)
            case "$QUALITY" in
                standard) Q="-V 2" ;;
                small)    Q="-b 128" ;;
                *)        Q="-V 0" ;;
            esac
            lame $Q "$src" "$dest"
            ;;
        ogg)
            case "$QUALITY" in
                standard) Q="-q 5" ;;
                small)    Q="-q 3" ;;
                *)        Q="-q 8" ;;
            esac
            oggenc $Q "$src" -o "$dest"
            ;;
        opus)
            case "$QUALITY" in
                standard) Q="--bitrate 128" ;;
                small)    Q="--bitrate 64" ;;
                *)        Q="--bitrate 192" ;;
            esac
            opusenc $Q "$src" "$dest"
            ;;
        flac)
            flac --best "$src" -o "$dest"
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Process playlist
# ---------------------------------------------------------------------------
cd "$MUSIC_ROOT" || exit 1

ERRORS=0
COUNT=0

while IFS= read -r src_file || [ -n "$src_file" ]; do
    [[ -z "$src_file" || "$src_file" == \#* ]] && continue

    if [ ! -f "$src_file" ]; then
        echo -e "${YELLOW}⚠ Not found, skipping: $src_file${NC}"
        ((ERRORS++))
        continue
    fi

    src_dir=$(dirname "$src_file")
    dest_dir="$src_dir/${FORMAT}_enc"
    base_name=$(basename "$src_file")
    base_name="${base_name%.*}"

    echo -e "${CYAN}· $base_name${NC}"
    if encode_file "$src_file" "$dest_dir" "$base_name"; then
        echo -e "${GREEN}  ✓ → $dest_dir/$base_name.$FORMAT${NC}"
        ((COUNT++))
    else
        echo -e "${RED}  ✗ Failed: $src_file${NC}"
        ((ERRORS++))
    fi
done < "$M3U_FILE"

echo ""
if [ "$ERRORS" -eq 0 ]; then
    echo -e "${GREEN}${BOLD}✓ Conversion complete. $COUNT file(s) converted.${NC}"
else
    echo -e "${YELLOW}${BOLD}⚠ Done with $ERRORS error(s). $COUNT file(s) converted.${NC}"
fi
