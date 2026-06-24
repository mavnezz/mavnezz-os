# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

mavnezz-os is a flake-based NixOS configuration that manages multiple computers (desktop + laptop) from a single repo. It's centred around the Niri scrollable-tiling Wayland compositor with the Noctalia shell.

## Common Development Commands

## Do's and Don'ts
- Don't add unnecessary dependencies
- Don't modify core system files without understanding their purpose
- Don't add code that doesn't serve a purpose for the current task
- Don't add anything extra with out asking first.
- Do use dcli commands when possible

### Building and Deployment
```bash
# Build configuration for current host
dcli rebuild

# Update flake inputs and rebuild
dcli update

# Build specific host (no activation)
dcli build nix-desktop

# Deploy to specific host
dcli deploy nix-desktop

# Interactive host switcher
dcli switch-host
```

### Testing and Validation
```bash
# Build configuration to test changes (no activation)
nixos-rebuild build --flake .#HOST-NAME

# Show detailed error trace for debugging
nixos-rebuild build --flake .#HOST-NAME --show-trace

# Generate system diagnostic report
dcli diag
```

### Maintenance
```bash
# Clean old generations
dcli cleanup

# List available hosts
dcli list-hosts

# Trim SSD for performance
dcli trim
```

## Architecture Overview

### Multi-Host Configuration System
- **Flake-based**: Uses Nix flakes for reproducible builds and dependency management
- **Host-specific configs**: Each computer has its own directory under `hosts/`
- **Hardware profiles**: GPU-specific configurations in `profiles/` (nvidia, nvidia-laptop, amd, intel, vm)
- **Modular design**: Core system modules, drivers, and home-manager configs are separated

### Key Directories
- `devices/desktop/`, `devices/laptop/`: Per-machine NixOS modules (hardware.nix + default.nix)
- `modules/`: System modules (`niri.nix`, `packages.nix`, etc.) keyed by `workstation.*` options
- `home/`: Home-manager user environment (`niri.nix`, `common.nix`, `zsh.nix`, `vscode.nix`, `scripts/`)
- `config/niri/`: Niri compositor KDL configs (`config.desktop.kdl`, `config.laptop.kdl`, `noctalia.kdl`)
- `pkgs/`: Custom Nix derivations

### Configuration Flow
1. `flake.nix` defines `nixosConfigurations` via the `mkWorkstation` helper
2. Each device module (`devices/<form>/<host>/default.nix`) imports `hardware.nix` and enables `workstation.*` options
3. Home-manager imports from `home/` are shared across all hosts
4. `home/niri.nix` selects the per-host Niri KDL config based on `hostName`

### Flake Configuration (`flake.nix`)
- Inputs: `nixpkgs` 25.11, `nixpkgs-unstable`, `home-manager`, `nixos-hardware`, `noctalia`
- Creates host configurations using the `mkWorkstation` helper function
- Hosts: `homework`, `work`, `surface`

## dcli Command Line Tool

mavnezz-os includes a custom CLI utility (`dcli`) for system management:

### Essential Commands
- `dcli rebuild`: Rebuild current host
- `dcli update`: Update and rebuild current host
- `dcli build HOST`: Build specific host configuration
- `dcli deploy HOST`: Build and switch to host configuration
- `dcli list-hosts`: Show available hosts
- `dcli cleanup`: Remove old generations

### Shell Aliases
- `fr`: Fast rebuild (`dcli rebuild`)
- `fu`: Fast update (`dcli update`)
- `hosts`: List hosts (`dcli list-hosts`)
- `switch`: Interactive host switcher (`dcli switch-host`)

## Hardware Support

### GPU Profiles
- **nvidia**: Desktop NVIDIA (dedicated GPU)
- **nvidia-laptop**: Laptop NVIDIA + Intel hybrid (Prime support)
- **amd**: AMD Radeon graphics
- **intel**: Intel integrated graphics
- **vm**: Virtual machine optimized

### Adding New Hosts
1. Create a new directory under `devices/<form>/<host>/` with `default.nix` and `hardware.nix`
2. Generate hardware config: `nixos-generate-config --show-hardware-config > ./devices/<form>/<host>/hardware.nix`
3. Add a Niri config if the host needs one that differs from `config.desktop.kdl`/`config.laptop.kdl`
4. Add the host to `nixosConfigurations` in `flake.nix`
5. Test build: `dcli build NEW-HOST`

## Common Development Tasks

### Modifying System Packages
- System-wide: Edit `modules/packages.nix` (toggled via `workstation.baseline.packages.*`)
- Niri-specific: Edit `modules/niri.nix`

### Desktop Customization
- Wallpapers: Add to `wallpapers/`
- Niri configs: Edit `config/niri/config.desktop.kdl` / `config.laptop.kdl`
- Noctalia shell config: `config/niri/noctalia.kdl`

### Hardware Configuration Updates
- Monitor setup: Edit `output` blocks in the relevant `config/niri/config.*.kdl`
- Run `niri msg outputs` to list available outputs

## Troubleshooting

### Build Failures
1. Check git status: `dcli status`
2. Generate diagnostic: `dcli diag`
3. Build with trace: `nixos-rebuild build --flake .#HOST --show-trace`
4. Verify host exists: `dcli list-hosts`

### Hardware Detection
- Find GPU IDs: `lspci | grep VGA`
- Monitor detection: `niri msg outputs`
- Generate new hardware config if needed

### Common Issues
- **Host not found**: Check hostname matches a directory under `devices/<form>/`
- **Monitor issues**: Adjust the relevant `output` block in `config/niri/config.*.kdl`
- **Build cache issues**: Run `dcli cleanup` to clear old generations

## Development Workflow

1. Make configuration changes
2. Test build: `dcli build HOST-NAME`
3. If successful, deploy: `dcli deploy HOST-NAME`
4. Commit changes: `dcli commit "description"`
5. Push to repository: `dcli push`

## Repository Structure Notes

- Uses NixOS 25.11 stable with `nixpkgs-unstable` for select packages
- Home-manager for user environment management
- Noctalia shell (via the `noctalia` flake input) for the desktop UI