#!/bin/bash

# SH_main.sh
# Bootstrap orchestrator for a fresh Void Linux install.
# Calls sub-scripts in order, allowing each step to be skipped.
#
# Usage: bash SH_main.sh
#
# Step order:
#   00 — connect_wifi        (wpa_supplicant temporary connection)
#   01 — install_packages    (xbps install from dotfiles package lists)
#   02 — setup_services      (enable/disable runit services)
#   03 — deploy_dotfiles     (stow from dotfiles repo)
#   04 — setup_keyd          (copy keyd config and reload)
#   05 — setup_nm            (swap wpa_supplicant → NetworkManager)
#   06 — tty1_autologin      (configure agetty-tty1)
#   07 — setup_polkit        (power management rules)
#   08 — rename_xdg_dirs     (rename home dirs per user-dirs.dirs)
#   09 — ssh_perms           (fix ~/.ssh permissions)
#   10 — fonts_install       (JetBrainsMono Nerd Font)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# ---------------------------------------------------------------------------
# Config
# ---------------------------------------------------------------------------
SCRIPTS_DIR="${SCRIPTS_DIR:-$(dirname "$(realpath "$0")")}"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/.dotfiles}"
LOG_FILE="/tmp/SH_main_$(date +%Y%m%d_%H%M%S).log"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

step_header() {
    local num="$1"
    local name="$2"
    log "\n${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    log "${BLUE}${BOLD}  Step $num — $name${NC}"
    log "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

ask_step() {
    local label="$1"
    echo -e "${CYAN}Run: ${BOLD}$label${NC}? [y/n/q]: \c"
    read -r ans
    case "${ans,,}" in
        y) return 0 ;;
        q) log "\n${YELLOW}Quit requested. Exiting.${NC}"; exit 0 ;;
        *) return 1 ;;
    esac
}

run_script() {
    local script="$1"
    shift
    local args=("$@")
    local path="$SCRIPTS_DIR/$script"

    if [ ! -f "$path" ]; then
        log "${RED}✗ Script not found: $path${NC}"
        return 1
    fi

    bash "$path" "${args[@]}" 2>&1 | tee -a "$LOG_FILE"
    return "${PIPESTATUS[0]}"
}

# ---------------------------------------------------------------------------
# Preflight
# ---------------------------------------------------------------------------
clear
log "${BLUE}${BOLD}"
log "  ╔══════════════════════════════════════╗"
log "  ║       SH_main.sh — Void Bootstrap   ║"
log "  ╚══════════════════════════════════════╝"
log "${NC}"
log "  ${YELLOW}Scripts dir :${NC} $SCRIPTS_DIR"
log "  ${YELLOW}Dotfiles dir:${NC} $DOTFILES_DIR"
log "  ${YELLOW}Log file    :${NC} $LOG_FILE"
log "  ${YELLOW}Date        :${NC} $(date)"
log ""
log "  Steps will be presented one at a time."
log "  ${CYAN}y${NC} = run  ${YELLOW}n${NC} = skip  ${RED}q${NC} = quit\n"

if ! command -v xbps-install &>/dev/null; then
    log "${RED}This script is Void Linux only.${NC}"
    exit 1
fi

read -rp "Begin bootstrap? [y/N]: " start
[[ "${start,,}" != "y" ]] && { echo -e "${YELLOW}Aborted.${NC}"; exit 0; }

declare -a SKIPPED
declare -a FAILED
declare -a COMPLETED

# ---------------------------------------------------------------------------
# Step 00 — WiFi
# ---------------------------------------------------------------------------
step_header "00" "Connect WiFi"
if ask_step "SH_connect_wifi.sh"; then
    if run_script "SH_connect_wifi.sh"; then
        COMPLETED+=("00 — connect_wifi")
    else
        log "${RED}✗ Step 00 failed.${NC}"
        FAILED+=("00 — connect_wifi")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("00 — connect_wifi")
fi

# ---------------------------------------------------------------------------
# Step 01 — Install Packages
# ---------------------------------------------------------------------------
step_header "01" "Install Packages"
log "${CYAN}Profiles available in $DOTFILES_DIR:${NC}"
ls "$DOTFILES_DIR" 2>/dev/null | grep -v '^\.' | sed 's/^/  /'
echo ""
read -rp "Profile(s) to install (space-separated, e.g. 'common templar'): " profiles
if ask_step "SH_install_packages.sh $profiles"; then
    if run_script "SH_install_packages.sh" $profiles; then
        COMPLETED+=("01 — install_packages")
    else
        log "${RED}✗ Step 01 failed.${NC}"
        FAILED+=("01 — install_packages")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("01 — install_packages")
fi

# ---------------------------------------------------------------------------
# Step 02 — Setup Services
# ---------------------------------------------------------------------------
step_header "02" "Setup Services"
if ask_step "SH_setup_services.sh"; then
    if run_script "SH_setup_services.sh"; then
        COMPLETED+=("02 — setup_services")
    else
        log "${RED}✗ Step 02 failed.${NC}"
        FAILED+=("02 — setup_services")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("02 — setup_services")
fi

# ---------------------------------------------------------------------------
# Step 03 — Deploy Dotfiles
# ---------------------------------------------------------------------------
step_header "03" "Deploy Dotfiles"
log "${CYAN}Stow packages available:${NC}"
ls "$DOTFILES_DIR" 2>/dev/null | grep -v '^\.' | sed 's/^/  /'
echo ""
read -rp "Paths to stow (space-separated, e.g. 'common templar wm/niri'): " stow_paths
if ask_step "SH_stow_handler_stower.sh $stow_paths"; then
    if run_script "SH_stow_handler_stower.sh" $stow_paths; then
        COMPLETED+=("03 — deploy_dotfiles")
    else
        log "${RED}✗ Step 03 failed.${NC}"
        FAILED+=("03 — deploy_dotfiles")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("03 — deploy_dotfiles")
fi

# ---------------------------------------------------------------------------
# Step 04 — Setup Keyd
# ---------------------------------------------------------------------------
step_header "04" "Setup Keyd Configuration"
if ask_step "SH_setup_keyd.sh"; then
    if run_script "SH_setup_keyd.sh"; then
        COMPLETED+=("04 — setup_keyd")
    else
        log "${RED}✗ Step 04 failed.${NC}"
        FAILED+=("04 — setup_keyd")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("04 — setup_keyd")
fi

# ---------------------------------------------------------------------------
# Step 05 — Setup NetworkManager
# ---------------------------------------------------------------------------
step_header "05" "Migrate to NetworkManager"
if ask_step "SH_setup_nm.sh"; then
    if run_script "SH_setup_nm.sh"; then
        COMPLETED+=("05 — setup_nm")
    else
        log "${RED}✗ Step 05 failed.${NC}"
        FAILED+=("05 — setup_nm")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("05 — setup_nm")
fi

# ---------------------------------------------------------------------------
# Step 06 — TTY1 Autologin
# ---------------------------------------------------------------------------
step_header "06" "TTY1 Autologin"
log "${CYAN}Current user: $(whoami)${NC}"
if ask_step "SH_tty1_autologin.sh"; then
    if run_script "SH_tty1_autologin.sh" "$(whoami)"; then
        COMPLETED+=("06 — tty1_autologin")
    else
        log "${RED}✗ Step 06 failed.${NC}"
        FAILED+=("06 — tty1_autologin")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("06 — tty1_autologin")
fi

# ---------------------------------------------------------------------------
# Step 07 — Polkit Rules
# ---------------------------------------------------------------------------
step_header "07" "Polkit Power Rules"
if ask_step "SH_setup_polkit.sh"; then
    if run_script "SH_setup_polkit.sh"; then
        COMPLETED+=("07 — setup_polkit")
    else
        log "${RED}✗ Step 07 failed.${NC}"
        FAILED+=("07 — setup_polkit")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("07 — setup_polkit")
fi

# ---------------------------------------------------------------------------
# Step 08 — Rename XDG Dirs
# ---------------------------------------------------------------------------
step_header "08" "Rename XDG Directories"
if ask_step "SH_rename_xdg_dirs.sh"; then
    if run_script "SH_rename_xdg_dirs.sh"; then
        COMPLETED+=("08 — rename_xdg_dirs")
    else
        log "${RED}✗ Step 08 failed.${NC}"
        FAILED+=("08 — rename_xdg_dirs")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("08 — rename_xdg_dirs")
fi

# ---------------------------------------------------------------------------
# Step 09 — SSH Permissions
# ---------------------------------------------------------------------------
step_header "09" "SSH Permissions"
if ask_step "SH_ssh_perms.sh"; then
    if run_script "SH_ssh_perms.sh"; then
        COMPLETED+=("09 — ssh_perms")
    else
        log "${RED}✗ Step 09 failed.${NC}"
        FAILED+=("09 — ssh_perms")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("09 — ssh_perms")
fi

# ---------------------------------------------------------------------------
# Step 10 — JetBrainsMono Font
# ---------------------------------------------------------------------------
step_header "10" "Install Fonts"
if ask_step "SH_fonts_install.sh"; then
    if run_script "SH_fonts_install.sh"; then
        COMPLETED+=("10 — fonts_install")
    else
        log "${RED}✗ Step 10 failed.${NC}"
        FAILED+=("10 — fonts_install")
        read -rp "Continue anyway? [y/N]: " cont
        [[ "${cont,,}" != "y" ]] && exit 1
    fi
else
    SKIPPED+=("10 — install_jetbrains")
fi

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
log "\n${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
log "${BLUE}${BOLD}  Bootstrap Summary${NC}"
log "${BLUE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

if [ ${#COMPLETED[@]} -gt 0 ]; then
    log "${GREEN}${BOLD}Completed (${#COMPLETED[@]}):${NC}"
    for s in "${COMPLETED[@]}"; do log "  ${GREEN}✓ $s${NC}"; done
    echo ""
fi

if [ ${#SKIPPED[@]} -gt 0 ]; then
    log "${YELLOW}${BOLD}Skipped (${#SKIPPED[@]}):${NC}"
    for s in "${SKIPPED[@]}"; do log "  ${YELLOW}⊘ $s${NC}"; done
    echo ""
fi

if [ ${#FAILED[@]} -gt 0 ]; then
    log "${RED}${BOLD}Failed (${#FAILED[@]}):${NC}"
    for s in "${FAILED[@]}"; do log "  ${RED}✗ $s${NC}"; done
    echo ""
fi

log "${CYAN}Full log saved to: $LOG_FILE${NC}\n"

if [ ${#FAILED[@]} -eq 0 ]; then
    log "${GREEN}${BOLD}✓ Bootstrap complete.${NC}\n"
else
    log "${YELLOW}${BOLD}⚠ Bootstrap finished with ${#FAILED[@]} failure(s).${NC}\n"
fi
