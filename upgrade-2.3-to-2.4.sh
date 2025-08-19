#!/usr/bin/env bash

##########################################
# ZaneyOS Upgrade Script: 2.3 → 2.4
# Author: Don Williams
# Date: $(date +"%B %d, %Y")
##########################################

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Define directories
ZANEYOS_DIR="$HOME/zaneyos"
BACKUP_BASE_DIR="$HOME/.config/zaneyos-backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_DIR="$BACKUP_BASE_DIR/zaneyos-2.3-upgrade-backup-$TIMESTAMP"

# Define log file
LOG_FILE="$HOME/zaneyos-upgrade-$TIMESTAMP.log"

# Redirect all output to log file while still showing on screen
exec > >(tee -a "$LOG_FILE") 2>&1

# Function to print a section header
print_header() {
  echo -e "${BLUE}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║ ${1} ${NC}"
  echo -e "${BLUE}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to print an error message
print_error() {
  echo -e "${RED}❌ Error: ${1}${NC}"
}

# Function to print a warning message
print_warning() {
  echo -e "${YELLOW}⚠️  Warning: ${1}${NC}"
}

# Function to print a success message
print_success() {
  echo -e "${GREEN}✅ ${1}${NC}"
}

# Function to print an info message
print_info() {
  echo -e "${CYAN}ℹ️  ${1}${NC}"
}

# Function to create full backup
create_backup() {
    print_header "Creating Complete Backup"
    
    if [ ! -d "$ZANEYOS_DIR" ]; then
        print_error "ZaneyOS directory not found at $ZANEYOS_DIR"
        return 1
    fi
    
    print_info "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
    
    print_info "Copying entire zaneyos directory..."
    if cp -r "$ZANEYOS_DIR" "$BACKUP_DIR/"; then
        print_success "Backup created successfully at: $BACKUP_DIR"
        echo -e "${GREEN}📁 Backup location: $BACKUP_DIR/zaneyos${NC}"
        return 0
    else
        print_error "Failed to create backup"
        return 1
    fi
}

# Function to revert from backup
revert_from_backup() {
    print_header "Reverting from Backup"
    
    if [ ! -d "$BACKUP_DIR/zaneyos" ]; then
        print_error "Backup not found at $BACKUP_DIR/zaneyos"
        echo -e "${YELLOW}Available backups:${NC}"
        ls -la "$BACKUP_BASE_DIR/" 2>/dev/null || echo "No backups found"
        return 1
    fi
    
    print_warning "This will completely restore your ZaneyOS 2.3 configuration"
    echo -e "${YELLOW}Current zaneyos directory will be replaced with backup${NC}"
    
    read -p "Are you sure you want to revert? (Y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Revert cancelled"
        return 1
    fi
    
    # Remove current directory
    print_info "Removing current zaneyos directory..."
    if [ -d "$ZANEYOS_DIR" ]; then
        rm -rf "$ZANEYOS_DIR"
    fi
    
    # Restore from backup
    print_info "Restoring from backup..."
    if cp -r "$BACKUP_DIR/zaneyos" "$HOME/"; then
        print_success "Successfully reverted to ZaneyOS 2.3 backup"
        
        # Change to the restored directory
        cd "$ZANEYOS_DIR" || return 1
        
        # Get the profile from flake.nix
        local profile=$(grep 'profile = ' ./flake.nix | sed 's/.*= *"\([^"]*\)".*/\1/')
        
        print_info "Rebuilding system with restored configuration..."
        if command -v nh &> /dev/null; then
            nh os boot ~/zaneyos --hostname "$profile"
        else
            sudo nixos-rebuild boot --flake ~/zaneyos/#"$profile"
        fi
        
        if [ $? -eq 0 ]; then
            print_success "System successfully reverted to ZaneyOS 2.3"
            echo -e "${YELLOW}Please reboot to complete the reversion${NC}"
        else
            print_error "Failed to rebuild system after revert"
            return 1
        fi
        
        return 0
    else
        print_error "Failed to restore from backup"
        return 1
    fi
}

# Function to print success banner
print_success_banner() {
  echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║                 ZaneyOS 2.4 Upgrade Successful!                      ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}║   🎉 Your system has been upgraded to ZaneyOS 2.4                    ║${NC}"
  echo -e "${GREEN}║   🔄 Please reboot your system for changes to take full effect       ║${NC}"
  echo -e "${GREEN}║   🖥️  SDDM is now the default display manager                         ║${NC}"
  echo -e "${GREEN}║                                                                       ║${NC}"
  echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to print failure banner
print_failure_banner() {
  echo -e "${RED}╔═══════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║                 ZaneyOS 2.4 Upgrade Failed!                          ║${NC}"
  echo -e "${RED}║                                                                       ║${NC}"
  echo -e "${RED}║   Please review the log file for details:                             ║${NC}"
  echo -e "${RED}║   ${LOG_FILE}                                                         ║${NC}"
  echo -e "${RED}║                                                                       ║${NC}"
  echo -e "${RED}╚═══════════════════════════════════════════════════════════════════════╝${NC}"
}

# Check command line arguments
if [ "$1" = "--revert" ]; then
    revert_from_backup
    exit $?
fi

print_header "ZaneyOS 2.3 → 2.4 Upgrade Script"

echo -e "${CYAN}🚀 Welcome to the ZaneyOS 2.4 Upgrade Script!${NC}"
echo ""
echo -e "${YELLOW}📋 This script will:${NC}"
echo -e "  • Create a complete backup of your current system"
echo -e "  • Verify you're currently running ZaneyOS 2.3"
echo -e "  • Upgrade to ZaneyOS 2.4 from main branch"
echo -e "  • Merge new 2.4 variables into your host configuration"
echo -e "  • Handle terminal dependencies automatically"
echo -e "  • Use safe 'boot' option to avoid SDDM display issues"
echo -e "  • Prompt for reboot after completion"
echo ""
echo -e "${CYAN}💾 Revert Instructions:${NC}"
echo -e "  If something goes wrong, run: $0 --revert"
echo ""

# Change to zaneyos directory
if [ ! -d "$ZANEYOS_DIR" ]; then
    print_error "ZaneyOS directory not found at $ZANEYOS_DIR"
    print_error "Please ensure ZaneyOS is installed at ~/zaneyos"
    exit 1
fi

cd "$ZANEYOS_DIR" || exit 1

print_header "Pre-Flight Checks"

# Check if we're in a ZaneyOS directory
if [ ! -f "./flake.nix" ] || [ ! -d "./hosts" ]; then
  print_error "This doesn't appear to be a ZaneyOS directory."
  print_error "Please ensure you're in the correct directory."
  exit 1
fi

print_success "ZaneyOS directory structure detected"

# Check if git is available
if ! command -v git &> /dev/null; then
  print_error "Git is not installed."
  exit 1
fi

print_success "Git is available"

# Check if NH is available (we'll use it for the rebuild)
if ! command -v nh &> /dev/null; then
  print_warning "NH (Nix Helper) not found. Will use nixos-rebuild directly."
  USE_NH=false
else
  print_success "NH (Nix Helper) detected"
  USE_NH=true
fi

print_header "Version Verification"

# Check current branch/version
CURRENT_BRANCH=$(git branch --show-current)
print_info "Current branch: $CURRENT_BRANCH"

# Verify this appears to be version 2.3
if [ ! -f "./hosts/default/variables.nix" ]; then
  print_error "Cannot find default variables.nix file"
  exit 1
fi

# Check if we have 2.4 features (this indicates we're not on 2.3)
if grep -q "displayManager" ./hosts/default/variables.nix; then
  print_error "This appears to already be ZaneyOS 2.4 or newer"
  print_error "This upgrade script is only for 2.3 → 2.4 upgrades"
  print_info "Current variables.nix already contains 2.4+ features"
  exit 1
fi

print_success "Verified: This appears to be ZaneyOS 2.3"

# Create backup FIRST before making any changes
if ! create_backup; then
    print_error "Failed to create backup. Aborting upgrade."
    exit 1
fi

# Confirm with user before proceeding
echo ""
echo -e "${GREEN}✅ Backup created successfully!${NC}"
echo -e "${YELLOW}📍 Backup location: $BACKUP_DIR${NC}"
echo ""
read -p "Continue with the upgrade to ZaneyOS 2.4? (Y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Upgrade cancelled by user."
    print_info "Your backup is preserved at: $BACKUP_DIR"
    exit 0
fi

print_header "Fetching ZaneyOS 2.4"

# Fetch the latest from main branch
print_info "Fetching latest changes from origin..."
git fetch origin

print_info "Switching to main branch (ZaneyOS 2.4)..."
git checkout main
git pull origin main

print_success "Successfully switched to ZaneyOS 2.4 (main branch)"

print_header "Discovering Host Configurations"

# Find all host directories (excluding default)
HOST_DIRS=()
for dir in hosts/*/; do
    hostname=$(basename "$dir")
    if [ "$hostname" != "default" ]; then
        HOST_DIRS+=("$hostname")
    fi
done

if [ ${#HOST_DIRS[@]} -eq 0 ]; then
    print_error "No custom host configurations found"
    print_error "This upgrade script requires at least one custom host configuration"
    exit 1
fi

print_success "Found ${#HOST_DIRS[@]} host configuration(s): ${HOST_DIRS[*]}"

print_header "Upgrading Host Configurations"

# Function to merge variables from 2.3 to 2.4
merge_variables() {
    local hostname=$1
    local old_vars_file="$BACKUP_DIR/zaneyos/hosts/$hostname/variables.nix"
    local new_vars_file="./hosts/$hostname/variables.nix"
    
    print_info "Processing host: $hostname"
    
    # Create host directory if it doesn't exist
    mkdir -p "./hosts/$hostname"
    
    # Copy the new 2.4 template
    cp "./hosts/default/variables.nix" "$new_vars_file"
    
    # Extract values from old 2.3 configuration
    if [ -f "$old_vars_file" ]; then
        # Extract key values using more robust parsing
        local git_username=$(grep 'gitUsername' "$old_vars_file" | sed 's/.*= *"\([^"]*\)".*/\1/')
        local git_email=$(grep 'gitEmail' "$old_vars_file" | sed 's/.*= *"\([^"]*\)".*/\1/')
        local browser=$(grep 'browser' "$old_vars_file" | sed 's/.*= *"\([^"]*\)".*/\1/')
        local terminal=$(grep 'terminal' "$old_vars_file" | sed 's/.*= *"\([^"]*\)".*/\1/')
        local keyboard_layout=$(grep 'keyboardLayout' "$old_vars_file" | sed 's/.*= *"\([^"]*\)".*/\1/')
        local console_keymap=$(grep 'consoleKeyMap' "$old_vars_file" | sed 's/.*= *"\([^"]*\)".*/\1/')
        local enable_nfs=$(grep 'enableNFS' "$old_vars_file" | sed 's/.*= *\([^;]*\);.*/\1/')
        local print_enable=$(grep 'printEnable' "$old_vars_file" | sed 's/.*= *\([^;]*\);.*/\1/')
        local thunar_enable=$(grep 'thunarEnable' "$old_vars_file" | sed 's/.*= *\([^;]*\);.*/\1/')
        local clock_24h=$(grep 'clock24h' "$old_vars_file" | sed 's/.*= *\([^;]*\);.*/\1/')
        
        # Apply the values to new configuration
        [ -n "$git_username" ] && sed -i "s/gitUsername = \".*\";/gitUsername = \"$git_username\";/" "$new_vars_file"
        [ -n "$git_email" ] && sed -i "s/gitEmail = \".*\";/gitEmail = \"$git_email\";/" "$new_vars_file"
        [ -n "$browser" ] && sed -i "s/browser = \".*\";/browser = \"$browser\";/" "$new_vars_file"
        [ -n "$terminal" ] && sed -i "s/terminal = \".*\";/terminal = \"$terminal\";/" "$new_vars_file"
        [ -n "$keyboard_layout" ] && sed -i "s/keyboardLayout = \".*\";/keyboardLayout = \"$keyboard_layout\";/" "$new_vars_file"
        [ -n "$console_keymap" ] && sed -i "s/consoleKeyMap = \".*\";/consoleKeyMap = \"$console_keymap\";/" "$new_vars_file"
        [ -n "$enable_nfs" ] && sed -i "s/enableNFS = .*/enableNFS = $enable_nfs;/" "$new_vars_file"
        [ -n "$print_enable" ] && sed -i "s/printEnable = .*/printEnable = $print_enable;/" "$new_vars_file"
        [ -n "$thunar_enable" ] && sed -i "s/thunarEnable = .*/thunarEnable = $thunar_enable;/" "$new_vars_file"
        [ -n "$clock_24h" ] && sed -i "s/clock24h = .*/clock24h = $clock_24h;/" "$new_vars_file"
        
        # Handle terminal-specific enables - CRITICAL for 2.4
        case "$terminal" in
            "alacritty")
                sed -i "s/alacrittyEnable = false;/alacrittyEnable = true;/" "$new_vars_file"
                print_success "✓ Enabled Alacritty for host $hostname"
                ;;
            "wezterm")
                sed -i "s/weztermEnable = false;/weztermEnable = true;/" "$new_vars_file"
                print_success "✓ Enabled WezTerm for host $hostname"
                ;;
            "ghostty")
                sed -i "s/ghosttyEnable = false;/ghosttyEnable = true;/" "$new_vars_file"
                print_success "✓ Enabled Ghostty for host $hostname"
                ;;
            "kitty")
                print_info "✓ Kitty is enabled by default"
                ;;
            *)
                print_warning "Unknown terminal '$terminal' - keeping kitty as default"
                sed -i "s/terminal = \".*\";/terminal = \"kitty\";/" "$new_vars_file"
                ;;
        esac
        
        # Copy stylixImage, waybarChoice, and animChoice if they exist
        local stylix_image=$(grep 'stylixImage' "$old_vars_file" | head -1)
        if [ -n "$stylix_image" ]; then
            # Replace the active stylixImage line
            local line_num=$(grep -n 'stylixImage = .*mountainscapedark.jpg;' "$new_vars_file" | cut -d: -f1)
            if [ -n "$line_num" ]; then
                sed -i "${line_num}s|.*|  $stylix_image|" "$new_vars_file"
                print_success "✓ Preserved stylixImage setting"
            fi
        fi
        
        local waybar_choice=$(grep 'waybarChoice = ' "$old_vars_file" | grep -v '^[[:space:]]*#')
        if [ -n "$waybar_choice" ]; then
            # Replace the active waybarChoice line
            local line_num=$(grep -n 'waybarChoice = .*waybar-curved.nix;' "$new_vars_file" | cut -d: -f1)
            if [ -n "$line_num" ]; then
                sed -i "${line_num}s|.*|  $waybar_choice|" "$new_vars_file"
                print_success "✓ Preserved waybarChoice setting"
            fi
        fi
        
        local anim_choice=$(grep 'animChoice = ' "$old_vars_file" | grep -v '^[[:space:]]*#')
        if [ -n "$anim_choice" ]; then
            # Replace the active animChoice line
            local line_num=$(grep -n 'animChoice = .*animations-def.nix;' "$new_vars_file" | cut -d: -f1)
            if [ -n "$line_num" ]; then
                sed -i "${line_num}s|.*|  $anim_choice|" "$new_vars_file"
                print_success "✓ Preserved animChoice setting"
            fi
        fi
        
        # Handle monitor settings
        local monitor_start=$(grep -n 'extraMonitorSettings = "' "$old_vars_file" | cut -d: -f1)
        if [ -n "$monitor_start" ]; then
            local monitor_end=$(tail -n +"$monitor_start" "$old_vars_file" | grep -n '";' | head -1 | cut -d: -f1)
            if [ -n "$monitor_end" ]; then
                local total_end=$((monitor_start + monitor_end - 1))
                local monitor_settings=$(sed -n "${monitor_start},${total_end}p" "$old_vars_file")
                
                # Replace the monitor settings in new file
                local new_monitor_start=$(grep -n 'extraMonitorSettings = "' "$new_vars_file" | cut -d: -f1)
                if [ -n "$new_monitor_start" ]; then
                    local new_monitor_end=$(tail -n +"$new_monitor_start" "$new_vars_file" | grep -n '";' | head -1 | cut -d: -f1)
                    if [ -n "$new_monitor_end" ]; then
                        local new_total_end=$((new_monitor_start + new_monitor_end - 1))
                        # Delete old monitor settings and insert new ones
                        sed -i "${new_monitor_start},${new_total_end}d" "$new_vars_file"
                        sed -i "$((new_monitor_start - 1))r /dev/stdin" "$new_vars_file" <<< "$monitor_settings"
                        print_success "✓ Preserved monitor settings"
                    fi
                fi
            fi
        fi
        
        print_success "Configuration merged for host: $hostname"
    else
        print_warning "No backup found for host: $hostname, using defaults"
    fi
    
    # Also copy hardware.nix if it exists
    if [ -f "$BACKUP_DIR/zaneyos/hosts/$hostname/hardware.nix" ]; then
        cp "$BACKUP_DIR/zaneyos/hosts/$hostname/hardware.nix" "./hosts/$hostname/"
        print_success "✓ Preserved hardware.nix for host: $hostname"
    fi
}

# Process each host
for hostname in "${HOST_DIRS[@]}"; do
    merge_variables "$hostname"
done

print_header "Building ZaneyOS 2.4"

print_warning "Using 'boot' option to avoid SDDM display issues"
print_info "This is safer than 'switch' when changing display managers"

# Get the profile from flake.nix
PROFILE=$(grep 'profile = ' ./flake.nix | sed 's/.*= *"\([^"]*\)".*/\1/')
print_info "Detected profile: $PROFILE"

# Build the system
echo ""
read -p "Ready to build ZaneyOS 2.4? This may take several minutes. (Y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Build cancelled. You can run this script again later."
    print_info "To revert to 2.3: $0 --revert"
    exit 0
fi

print_info "Starting build process..."

BUILD_SUCCESS=false

if [ "$USE_NH" = true ]; then
    print_info "Using NH for build..."
    if nh os boot ~/zaneyos --hostname "$PROFILE"; then
        BUILD_SUCCESS=true
    fi
else
    print_info "Using nixos-rebuild for build..."
    if sudo nixos-rebuild boot --flake ~/zaneyos/#"$PROFILE"; then
        BUILD_SUCCESS=true
    fi
fi

print_header "Upgrade Results"

if [ "$BUILD_SUCCESS" = true ]; then
    print_success_banner
    
    echo ""
    echo -e "${CYAN}🔧 Key Changes in ZaneyOS 2.4:${NC}"
    echo -e "  • SDDM is now the default display manager"
    echo -e "  • Terminal applications can be individually enabled/disabled"
    echo -e "  • New application enable/disable toggles available"
    echo -e "  • Improved configuration structure"
    echo ""
    
    echo -e "${YELLOW}📝 Next Steps:${NC}"
    echo -e "  1. Reboot your system to complete the upgrade"
    echo -e "  2. SDDM will be your new login screen"
    echo -e "  3. Your custom settings have been preserved"
    echo -e "  4. Check that all your preferred applications are still available"
    echo ""
    
    echo -e "${CYAN}🔄 Revert Option:${NC}"
    echo -e "  If you encounter issues, run: $0 --revert"
    echo -e "  Your 2.3 backup is preserved at: $BACKUP_DIR"
    echo ""
    
    # Prompt for reboot
    read -p "Would you like to reboot now? (Y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Rebooting in 5 seconds... (Press Ctrl+C to cancel)"
        sleep 5
        sudo reboot
    else
        echo -e "${GREEN}✅ Upgrade complete! Remember to reboot when convenient.${NC}"
    fi
    
else
    print_failure_banner
    echo ""
    echo -e "${YELLOW}🔄 Recovery Options:${NC}"
    echo -e "  • Run revert command: $0 --revert"
    echo -e "  • Your backup is available at: $BACKUP_DIR"
    echo -e "  • Review the log file: $LOG_FILE"
    echo ""
    
    read -p "Would you like to automatically revert to ZaneyOS 2.3? (Y/N): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        revert_from_backup
    else
        print_info "Manual revert available with: $0 --revert"
    fi
    
    exit 1
fi
