#!/bin/bash

# SH_export_bookmarks.sh
# Exports Brave bookmarks to your dotfiles repo with a timestamp,
# then commits and pushes automatically.
#
# Usage: bash SH_export_bookmarks.sh

DOTFILES_DIR="$HOME/.dotfiles"
BOOKMARKS_SRC="$HOME/.config/BraveSoftware/Brave-Browser/Default/Bookmarks"
BOOKMARKS_DEST_DIR="$DOTFILES_DIR/common/html_bookmarks"

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BLUE}${BOLD}=== SH_export_bookmarks.sh ===${NC}"
echo -e "${CYAN}Exports Brave bookmarks to your dotfiles repo with a timestamp,${NC}"
echo -e "${CYAN}converts them to HTML (Firefox/Chrome importable) and pushes to GitHub.${NC}"
echo -e "${CYAN}Each run saves a new snapshot — full history is preserved on GitHub.${NC}\n"
echo -e "  ${YELLOW}Usage    :${NC} bash SH_export_bookmarks.sh  (no arguments)"
echo -e "  ${YELLOW}Source   :${NC} $BOOKMARKS_SRC"
echo -e "  ${YELLOW}Dest     :${NC} $BOOKMARKS_DEST_DIR"
echo -e "  ${YELLOW}Filename :${NC} Bookmarks_YYYY-MM-DD_HH-MM.html"
echo -e "  ${YELLOW}Commit   :${NC} bookmarks: export YYYY-MM-DD_HH-MM\n"

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
if [ ! -f "$BOOKMARKS_SRC" ]; then
    echo -e "${RED}Error: Brave bookmarks file not found at $BOOKMARKS_SRC${NC}"
    echo -e "${YELLOW}Is Brave installed and has it been opened at least once?${NC}"
    exit 1
fi

if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    exit 1
fi

if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git not found.${NC}"
    exit 1
fi

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}Error: python3 not found — required for JSON to HTML conversion.${NC}"
    exit 1
fi


read -p "Proceed? [y/N]: " confirm
[[ "${confirm,,}" != "y" ]] && { echo -e "${YELLOW}Aborted. No changes made.${NC}"; exit 0; }
echo ""

# ---------------------------------------------------------------------------
# Export + Convert JSON → HTML
# ---------------------------------------------------------------------------
mkdir -p "$BOOKMARKS_DEST_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M")
FILENAME="Bookmarks_${TIMESTAMP}.html"
DEST="$BOOKMARKS_DEST_DIR/$FILENAME"

python3 - "$BOOKMARKS_SRC" "$DEST" << 'EOF'
import json, sys
from datetime import datetime

src, dest = sys.argv[1], sys.argv[2]

with open(src, "r", encoding="utf-8") as f:
    data = json.load(f)

lines = []
lines.append("<!DOCTYPE NETSCAPE-Bookmark-file-1>")
lines.append("<!-- This is an automatically generated file. -->")
lines.append('<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">')
lines.append(f"<!-- Exported from Brave on {datetime.now().strftime('%Y-%m-%d %H:%M')} -->")
lines.append("<TITLE>Bookmarks</TITLE>")
lines.append("<H1>Bookmarks</H1>")
lines.append("<DL><p>")

def process_node(node, indent=1):
    pad = "    " * indent
    node_type = node.get("type")

    if node_type == "url":
        name = node.get("name", "").replace("<", "&lt;").replace(">", "&gt;")
        url  = node.get("url", "")
        lines.append(f'{pad}<DT><A HREF="{url}">{name}</A>')

    elif node_type == "folder":
        name = node.get("name", "").replace("<", "&lt;").replace(">", "&gt;")
        lines.append(f"{pad}<DT><H3>{name}</H3>")
        lines.append(f"{pad}<DL><p>")
        for child in node.get("children", []):
            process_node(child, indent + 1)
        lines.append(f"{pad}</DL><p>")

roots = data.get("roots", {})
for key in ["bookmark_bar", "other", "synced"]:
    if key in roots:
        process_node(roots[key])

lines.append("</DL><p>")

with open(dest, "w", encoding="utf-8") as f:
    f.write("\n".join(lines))
EOF

if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Failed to convert bookmarks to HTML.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Bookmarks exported to:${NC} $DEST"

# ---------------------------------------------------------------------------
# Commit + Push
# ---------------------------------------------------------------------------
cd "$DOTFILES_DIR" || exit 1

git add "$DEST"

git commit -m "bookmarks: export $TIMESTAMP"

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠  Nothing new to commit — bookmarks may be unchanged.${NC}"
    exit 0
fi

echo -e "${CYAN}  Pushing to remote...${NC}"
git push

if [ $? -eq 0 ]; then
    echo -e "\n${GREEN}${BOLD}✅ Bookmarks backed up and pushed successfully.${NC}\n"
else
    echo -e "\n${RED}✗ Push failed. Commit was made locally — run 'git push' manually.${NC}\n"
    exit 1
fi
