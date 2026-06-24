# mavnezz-os Beginner’s Guide to Customization

Welcome! This guide is for users who are new to Nix and want to make common, safe customizations to their mavnezz-os setup. We’ll keep it simple and focus on essentials.

## Repository layout (where to change things)

- `flake.nix`: Entry point for the whole system. You generally don’t need to edit this for day‑to‑day tweaks.
- `devices/<form>/<hostname>/`: Per‑machine NixOS module — toggles features via `workstation.*` options and imports `hardware.nix`.
- `modules/`: Reusable building blocks. `modules/packages.nix` holds the shared baseline package set; `modules/niri.nix` wires up the compositor and shell.
- `home/`: Shared Home Manager imports (`niri.nix`, `common.nix`, `zsh.nix`, ...).
- `config/niri/`: Niri compositor configs (`config.desktop.kdl`, `config.laptop.kdl`) and Noctalia shell config (`noctalia.kdl`).

## Installing packages

Two common patterns:

### 1) Only on this machine
Add the package to `environment.systemPackages` inside `devices/<form>/<hostname>/default.nix`.

### 2) On all machines
Edit `modules/packages.nix` and add the package to the relevant list (`toolsPackages`, `devPackages`, or `appsPackages`).

## Monitor settings (per host)

Edit `config/niri/config.desktop.kdl` (or `config.laptop.kdl` for laptops) and adjust the `output` block:

```kdl
output "DP-1" {
    mode "1920x1080@144"
    position x=0 y=0
    scale 1.0
}
```

## Change Niri keybindings

Edit the `binds {}` section in `config/niri/config.desktop.kdl` (or `config.laptop.kdl`). For example:

```kdl
Mod+Return { spawn "ghostty"; }
```

## Apply and test your changes

Preferred:
- `dcli rebuild`
  - Note: The `fr` alias is deprecated.

Manual backup method (works anywhere):
- From the repo root, replace PROFILE with your host:
  - `sudo nixos-rebuild switch --flake .#PROFILE`

Tips
- If a rebuild fails, read the error near the bottom of the output—it usually points to the exact file/line.
- If a change breaks your session after a reboot, pick an older “generation” from the boot menu to roll back.
- Use Git to track your edits so you can revert easily.
