#!/bin/bash

# Stow Conflict Handler
# Detects conflicting files and offers to back them up or delete them

DOTFILES_DIR="${1:-$HOME/.dotfiles}"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if we're in the dotfiles directory
if [ ! -d "$DOTFILES_DIR" ]; then
    echo -e "${RED}Error: Dotfiles directory not found at $DOTFILES_DIR${NC}"
    exit 1
fi

cd "$DOTFILES_DIR" || exit 1

# Get list of packages (directories excluding hidden files and scripts)
PACKAGES=$(find . -maxdepth 1 -type d ! -name '.' ! -name '.git' ! -name '.*' -exec basename {} \;)

if [ -z "$PACKAGES" ]; then
    echo -e "${RED}No stow packages found in $DOTFILES_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}=== Stow Conflict Checker ===${NC}"
echo -e "Checking packages: ${GREEN}$PACKAGES${NC}\n"

# Array to store conflicts
declare -a CONFLICTS

# Check each package for conflicts
for package in $PACKAGES; do
    echo -e "${YELLOW}Checking $package...${NC}"
    
    # Run stow in simulation mode to detect conflicts
    STOW_OUTPUT=$(stow -n -v "$package" 2>&1)
    
    # Extract conflicting files from stow output
    PACKAGE_CONFLICTS=$(echo "$STOW_OUTPUT" | grep "existing target" | sed 's/.*existing target is neither a link nor a directory: //' | sed 's/.*existing target is not owned by stow: //')
    
    if [ -n "$PACKAGE_CONFLICTS" ]; then
        while IFS= read -r conflict; do
            if [ -n "$conflict" ]; then
                # Store absolute path by prepending HOME
                FULL_CONFLICT_PATH="$HOME/$conflict"
                CONFLICTS+=("$FULL_CONFLICT_PATH")
            fi
        done <<< "$PACKAGE_CONFLICTS"
    fi
done

# If no conflicts, proceed with stowing
if [ ${#CONFLICTS[@]} -eq 0 ]; then
    echo -e "\n${GREEN}✓ No conflicts found! Stowing packages...${NC}\n"
    for package in $PACKAGES; do
        echo -e "${GREEN}Stowing $package...${NC}"
        stow -v "$package"
    done
    echo -e "\n${GREEN}✓ All packages stowed successfully!${NC}"
    exit 0
fi

# Display conflicts
echo -e "\n${RED}⚠ Found ${#CONFLICTS[@]} conflicting file(s):${NC}"
for i in "${!CONFLICTS[@]}"; do
    # Display relative path for readability
    RELATIVE_PATH="${CONFLICTS[$i]#$HOME/}"
    echo -e "${YELLOW}  $((i+1)). $RELATIVE_PATH${NC}"
done

echo -e "\n${BLUE}Options:${NC}"
echo "  [A] Backup ALL conflicting files and proceed"
echo "  [D] Delete ALL conflicting files and proceed"
echo "  [I] Handle each file individually"
echo "  [Q] Quit without changes"
echo ""
read -p "Choose an option [A/D/I/Q]: " choice

case "${choice^^}" in
    A)
        # Backup all
        mkdir -p "$BACKUP_DIR"
        echo -e "\n${YELLOW}Backing up files to $BACKUP_DIR${NC}"
        
        for conflict in "${CONFLICTS[@]}"; do
            if [ -e "$conflict" ]; then
                # Extract relative path for backup structure
                RELATIVE_PATH="${conflict#$HOME/}"
                BACKUP_SUBDIR="$BACKUP_DIR/$(dirname "$RELATIVE_PATH")"
                mkdir -p "$BACKUP_SUBDIR"
                mv "$conflict" "$BACKUP_SUBDIR/"
                echo -e "${GREEN}✓ Backed up: $RELATIVE_PATH${NC}"
            fi
        done
        
        echo -e "\n${GREEN}Stowing packages...${NC}"
        for package in $PACKAGES; do
            stow -v "$package"
        done
        echo -e "\n${GREEN}✓ Done! Backups saved in $BACKUP_DIR${NC}"
        ;;
        
    D)
        # Delete all
        echo -e "\n${RED}⚠ WARNING: This will permanently delete ${#CONFLICTS[@]} file(s)!${NC}"
        read -p "Are you absolutely sure? Type 'DELETE' to confirm: " confirm
        
        if [ "$confirm" = "DELETE" ]; then
            for conflict in "${CONFLICTS[@]}"; do
                if [ -e "$conflict" ]; then
                    RELATIVE_PATH="${conflict#$HOME/}"
                    rm -rf "$conflict"
                    echo -e "${RED}✗ Deleted: $RELATIVE_PATH${NC}"
                fi
            done
            
            echo -e "\n${GREEN}Stowing packages...${NC}"
            for package in $PACKAGES; do
                stow -v "$package"
            done
            echo -e "\n${GREEN}✓ Done!${NC}"
        else
            echo -e "${YELLOW}Aborted. No changes made.${NC}"
            exit 1
        fi
        ;;
        
    I)
        # Handle individually
        mkdir -p "$BACKUP_DIR"
        
        for conflict in "${CONFLICTS[@]}"; do
            if [ ! -e "$conflict" ]; then
                continue
            fi
            
            RELATIVE_PATH="${conflict#$HOME/}"
            
            echo -e "\n${YELLOW}File: $RELATIVE_PATH${NC}"
            echo "  [B] Backup this file"
            echo "  [D] Delete this file"
            echo "  [S] Skip this file"
            echo "  [Q] Quit"
            
            read -p "Choose [B/D/S/Q]: " file_choice
            
            case "${file_choice^^}" in
                B)
                    BACKUP_SUBDIR="$BACKUP_DIR/$(dirname "$RELATIVE_PATH")"
                    mkdir -p "$BACKUP_SUBDIR"
                    mv "$conflict" "$BACKUP_SUBDIR/"
                    echo -e "${GREEN}✓ Backed up${NC}"
                    ;;
                D)
                    rm -rf "$conflict"
                    echo -e "${RED}✗ Deleted${NC}"
                    ;;
                S)
                    echo -e "${BLUE}⊘ Skipped${NC}"
                    ;;
                Q)
                    echo -e "${YELLOW}Quitting...${NC}"
                    exit 0
                    ;;
                *)
                    echo -e "${YELLOW}Invalid choice. Skipping...${NC}"
                    ;;
            esac
        done
        
        echo -e "\n${GREEN}Stowing packages...${NC}"
        for package in $PACKAGES; do
            stow -v "$package" 2>/dev/null || echo -e "${YELLOW}⚠ Some conflicts remain in $package${NC}"
        done
        
        if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
            echo -e "\n${GREEN}✓ Done! Backups saved in $BACKUP_DIR${NC}"
        else
            rm -rf "$BACKUP_DIR"
            echo -e "\n${GREEN}✓ Done!${NC}"
        fi
        ;;
        
    Q)
        echo -e "${YELLOW}Exiting without changes.${NC}"
        exit 0
        ;;
        
    *)
        echo -e "${RED}Invalid option. Exiting.${NC}"
        exit 1
        ;;
esac
