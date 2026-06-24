{
  pkgs,
  backupFiles ? [ ".config/mimeapps.list.backup" ],
  ...
}:
let
  backupFilesString = pkgs.lib.strings.concatStringsSep " " backupFiles;
in
pkgs.writeShellScriptBin "dcli" ''
  #!${pkgs.bash}/bin/bash
  set -euo pipefail

  # --- Configuration ---
  PROJECT="mavnezz-os"
  HOST="$(${pkgs.nettools}/bin/hostname)"
  BACKUP_FILES_STR="${backupFilesString}"
  VERSION="3.0.0"

  read -r -a BACKUP_FILES <<< "$BACKUP_FILES_STR"

  # --- Helper Functions ---
  print_help() {
    echo "mavnezz-os CLI Utility -- version $VERSION"
    echo ""
    echo "Usage: dcli [command]"
    echo ""
    echo "System Commands:"
    echo "  rebuild         - Rebuild the NixOS system configuration for current host ($HOST)."
    echo "  rebuild-boot    - Rebuild and set as boot default (activates on next restart)."
    echo "  update          - Update the flake and rebuild the system for current host."
    echo ""
    echo "Multi-Device Commands:"
    echo "  build [HOST]    - Build configuration for specific device (no activation)."
    echo "  deploy [HOST]   - Build and switch to specific device configuration."
    echo "  list-hosts      - List all available device configurations."
    echo ""
    echo "Maintenance Commands:"
    echo "  cleanup         - Clean up old system generations. Can specify a number to keep."
    echo "  diag            - Create a system diagnostic report (saves to ~/diag.txt)."
    echo "  list-gens       - List user and system generations."
    echo "  trim            - Trim filesystems to improve SSD performance."
    echo ""
    echo "Git Commands:"
    echo "  commit [msg]    - Add all changes and commit with message."
    echo "  push            - Push changes to origin."
    echo "  pull            - Pull latest changes from origin."
    echo "  status          - Show git status."
    echo ""
    echo "  help            - Show this help message."
    echo ""
    echo "Current Host: $HOST"
  }

  handle_backups() {
    if [ ''${#BACKUP_FILES[@]} -eq 0 ]; then
      echo "No backup files configured to check."
      return
    fi

    echo "Checking for backup files to remove..."
    for file_path in "''${BACKUP_FILES[@]}"; do
      full_path="$HOME/$file_path"
      if [ -f "$full_path" ]; then
        echo "Removing stale backup file: $full_path"
        rm "$full_path"
      fi
    done
  }

  list_available_hosts() {
    if [ ! -d "$HOME/$PROJECT/devices" ]; then
      echo "Error: Devices directory not found at $HOME/$PROJECT/devices" >&2
      return 1
    fi

    echo "Available devices:"
    for class_dir in "$HOME/$PROJECT/devices"/*; do
      [ -d "$class_dir" ] || continue
      class=$(basename "$class_dir")
      for dev_dir in "$class_dir"/*; do
        [ -d "$dev_dir" ] || continue
        name=$(basename "$dev_dir")
        if [ "$name" = "$HOST" ]; then
          echo "  • $name [$class] (current)"
        else
          echo "  • $name [$class]"
        fi
      done
    done
  }

  validate_host() {
    local target_host="$1"
    if ! ls -d "$HOME/$PROJECT/devices"/*/"$target_host" >/dev/null 2>&1; then
      echo "Error: Device '$target_host' not found under $HOME/$PROJECT/devices/" >&2
      list_available_hosts >&2
      return 1
    fi
    return 0
  }

  build_host() {
    local target_host="$1"
    validate_host "$target_host" || return 1

    echo "Building configuration for device: $target_host"
    cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; return 1; }

    if nixos-rebuild build --flake ".#$target_host"; then
      echo "✓ Build successful for $target_host"
      return 0
    else
      echo "✗ Build failed for $target_host" >&2
      return 1
    fi
  }

  deploy_host() {
    local target_host="$1"
    validate_host "$target_host" || return 1

    echo "Deploying configuration for device: $target_host"
    cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; return 1; }

    if sudo nixos-rebuild switch --flake ".#$target_host"; then
      echo "✓ Successfully deployed $target_host configuration"
      echo "System is now running $target_host configuration."
      return 0
    else
      echo "✗ Deployment failed for $target_host" >&2
      return 1
    fi
  }

  # --- Main Logic ---
  if [ "$#" -eq 0 ]; then
    echo "Error: No command provided." >&2
    print_help
    exit 1
  fi

  case "$1" in
    cleanup)
      echo "Warning! This will remove old generations of your system."
      read -p "How many generations to keep (default: all)? " keep_count

      if [ -z "$keep_count" ]; then
        read -p "This will remove all but the current generation. Continue (y/N)? " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          nh clean all -v
        else
          echo "Cleanup cancelled."
        fi
      else
        read -p "This will keep the last $keep_count generations. Continue (y/N)? " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
          nh clean all -k "$keep_count" -v
        else
          echo "Cleanup cancelled."
        fi
      fi

      LOG_DIR="$HOME/dcli-cleanup-logs"
      mkdir -p "$LOG_DIR"
      LOG_FILE="$LOG_DIR/dcli-cleanup-$(date +%Y-%m-%d_%H-%M-%S).log"
      echo "Cleaning up old log files..." >> "$LOG_FILE"
      find "$LOG_DIR" -type f -mtime +3 -name "*.log" -delete >> "$LOG_FILE" 2>&1
      echo "Cleanup process logged to $LOG_FILE"
      ;;
    diag)
      echo "Generating system diagnostic report..."
      {
        echo "=== mavnezz-os System Diagnostic Report ==="
        echo "Generated: $(date)"
        echo "Host: $HOST"
        echo ""
        echo "=== System Information ==="
        inxi --full 2>/dev/null || echo "inxi not available"
        echo ""
        echo "=== Git Status ==="
        cd "$HOME/$PROJECT" 2>/dev/null && git status 2>/dev/null || echo "Git status not available"
        echo ""
        echo "=== Available Devices ==="
        list_available_hosts 2>/dev/null || echo "Could not list devices"
      } > "$HOME/diag.txt"
      echo "Diagnostic report saved to $HOME/diag.txt"
      ;;
    help)
      print_help
      ;;
    list-gens)
      echo "--- User Generations ---"
      nix-env --list-generations | cat || echo "Could not list user generations."
      echo ""
      echo "--- System Generations ---"
      nix profile history --profile /nix/var/nix/profiles/system | cat || echo "Could not list system generations."
      ;;
    list-hosts)
      list_available_hosts
      ;;
    rebuild)
      handle_backups
      echo "Starting NixOS rebuild for current host: $HOST"
      cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; exit 1; }
      if sudo nixos-rebuild switch --flake ".#$HOST"; then
        echo "✓ Rebuild finished successfully for $HOST"
      else
        echo "✗ Rebuild failed for $HOST" >&2
        exit 1
      fi
      ;;
    rebuild-boot)
      handle_backups
      echo "Starting NixOS rebuild with boot option for current host: $HOST"
      cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; exit 1; }
      if sudo nixos-rebuild boot --flake ".#$HOST"; then
        echo "✓ Rebuild with boot option finished successfully for $HOST"
        echo "Changes will activate on next restart"
      else
        echo "✗ Rebuild with boot option failed for $HOST" >&2
        exit 1
      fi
      ;;
    update)
      handle_backups
      echo "Updating flake and rebuilding system for current host: $HOST"
      cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; exit 1; }

      if [ -x "$HOME/$PROJECT/scripts/update-snapmaker-orca.sh" ]; then
        echo ""
        echo "Checking for Snapmaker OrcaSlicer updates..."
        "$HOME/$PROJECT/scripts/update-snapmaker-orca.sh" || echo "⚠ Snapmaker update check skipped"
        echo ""
      fi

      if [ -x "$HOME/$PROJECT/scripts/update-bambu-studio.sh" ]; then
        echo ""
        echo "Checking for Bambu Studio updates..."
        "$HOME/$PROJECT/scripts/update-bambu-studio.sh" || echo "⚠ Bambu Studio update check skipped"
        echo ""
      fi

      echo "Updating flake..."
      if nix flake update; then
        echo "✓ Flake updated successfully"
      else
        echo "✗ Flake update failed" >&2
        exit 1
      fi

      echo "Rebuilding system..."
      if sudo nixos-rebuild switch --flake ".#$HOST"; then
        echo "✓ Update and rebuild finished successfully for $HOST"
      else
        echo "✗ Update and rebuild failed for $HOST" >&2
        exit 1
      fi
      ;;
    build)
      if [ "$#" -lt 2 ]; then
        echo "Usage: dcli build <hostname>" >&2
        list_available_hosts
        exit 1
      fi
      build_host "$2"
      ;;
    deploy)
      if [ "$#" -lt 2 ]; then
        echo "Usage: dcli deploy <hostname>" >&2
        list_available_hosts
        exit 1
      fi
      deploy_host "$2"
      ;;
    commit)
      cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; exit 1; }
      if [ "$#" -lt 2 ]; then
        read -p "Enter commit message: " commit_msg
      else
        shift
        commit_msg="$*"
      fi

      if [ -z "$commit_msg" ]; then
        echo "Error: Commit message cannot be empty" >&2
        exit 1
      fi

      git add -A && git commit -m "$commit_msg"
      ;;
    push)
      cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; exit 1; }
      git push origin "$(git branch --show-current)"
      ;;
    pull)
      cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; exit 1; }
      git pull origin "$(git branch --show-current)"
      ;;
    status)
      cd "$HOME/$PROJECT" || { echo "Error: Could not change to $HOME/$PROJECT"; exit 1; }
      git status
      ;;
    trim)
      echo "Running 'sudo fstrim -v /' may take a few minutes and impact system performance."
      read -p "Enter (y/Y) to run now or enter to exit (y/N): " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Running fstrim..."
        sudo fstrim -v /
        echo "fstrim complete."
      else
        echo "Trim operation cancelled."
      fi
      ;;
    *)
      echo "Error: Invalid command '$1'" >&2
      print_help
      exit 1
      ;;
  esac
''
