# Project Guide — Black Don OS

Scope
- A reproducible NixOS flake tailored for desktop systems with per-host overrides, GPU/VM profiles, and an integrated Home Manager layer (Hyprland, Waybar, shells, scripts).
- Repo location is expected at ~/black-don-os. If you place it elsewhere, update the appropriate configuration files to the new path.

Quick commands
- Build and switch (preferred: dcli)
  - fr  → dcli rebuild    # alias provided by zsh/bash modules
  - fu  → dcli update     # alias provided by zsh/bash modules
  - dcli rebuild
  - dcli update
- Build for next boot (safer for larger changes)
  - dcli build <hostname>
  - or: sudo nixos-rebuild boot --flake .#<hostname>
- Deploy to specific host
  - dcli deploy <hostname>
- Direct NixOS (if you prefer without dcli)
  - sudo nixos-rebuild switch --flake .#<hostname>
- Validate the flake
  - nix flake check
- Format Nix files (nixfmt-rfc-style is included)
  - find . -name "*.nix" -print0 | xargs -0 nixfmt
- Host management
  - dcli list-hosts      # show available hosts
  - dcli switch-host     # interactive host switcher
- Diagnostics and maintenance
  - dcli diag        # writes diagnostic report
  - dcli cleanup     # prunes older generations
  - dcli trim        # SSD maintenance

dcli options
- Available options vary by command
- Use dcli --help or dcli <command> --help for specific options

Hardware Profiles and when to use them
- amd, intel, nvidia, nvidia-laptop (hybrid), vm
- Choose with the hostname argument in dcli/nixos-rebuild commands (e.g., dcli deploy nix-desktop)

High-level architecture
- flake.nix
  - Inputs: nixpkgs 25.05, home-manager 25.05, stylix, etc.
  - Local constants: system, hostname, profile, username
  - nixosConfigurations: one per host via mkHost helper function
    - Each configuration imports profiles/<profile>
- profiles/<profile>/default.nix
  - Imports the active host and the system module stacks:
    - ../../hosts/${hostname}
    - ../../modules/drivers
    - ../../modules/core
  - Flips toggles: drivers.*.enable and vm.guest-services.enable
  - Hybrid laptops: profiles/nvidia-laptop pulls intel/nvidia Bus IDs from the host’s variables.nix and wires nvidia-prime
- hosts/<hostname>/
  - default.nix imports hardware.nix and host-packages.nix
  - variables.nix is the control panel for UX + feature toggles:
    - displayManager (greetd vs sddm)
    - terminal/browser defaults (enable per-terminal via flags)
    - waybarChoice, animChoice, stylixImage
    - 24h clock, thunarEnable, printEnable, NFS
    - intelID/nvidiaID for Prime offload
- modules/core
  - default.nix composes focused NixOS modules: boot, flatpak, fonts, hardware, network, nfs, packages, printing, display manager (conditional greetd/ly), security, services (PipeWire, SSH, Bluetooth, fstrim; smartd conditional on profile), steam, stylix, syncthing, system (nix settings, locales, env vars), thunar, user (Home Manager), virtualisation, xserver
  - user.nix integrates Home Manager and creates users.${username}; passes extraSpecialArgs { inputs, username, hostname, profile } to the home layer
- modules/drivers
  - Aggregates AMD, Intel, NVIDIA, NVIDIA Prime, and VM guest services
  - nvidia-prime-drivers.nix exposes options.drivers.nvidia-prime.{enable,intelBusID,nvidiaBusID} consumed by the nvidia-laptop profile
  - vm-guest-services.nix enables qemu-guest, spice agents when vm.guest-services.enable = true
- modules/home
  - default.nix composes the user environment (Hyprland, Waybar via waybarChoice, Rofi, Yazi, Kitty/WezTerm/Ghostty/Alacritty toggles, Zsh/Bash config, Git, Neovim, OBS, swaync, scripts, Stylix, optional applications)
  - scripts/default.nix installs user-space tools including dcli; dcli wraps rebuild/update/build/deploy commands, cleanup, diagnostics, and host management

Where to change what
- flake.nix: set username, host, profile; add inputs; wire outputs
- hosts/<hostname>/{variables.nix,hardware.nix,host-packages.nix}: per-machine behavior, theming, and hardware
- modules/core/*: system-level settings, services, packages
- modules/home/*: user apps, shell, window manager, UI

Common workflows
- Small UX tweaks: edit hosts/<hostname>/variables.nix → fr (dcli rebuild)
- Theme swap: edit stylixImage/waybarChoice in variables.nix → fr or dcli rebuild
- Host switch: use dcli switch-host for interactive selection or dcli deploy <hostname>

Validation and troubleshooting
- nix flake check for a quick sanity test
- dcli diag to produce a detailed hardware/system report
- dcli list-hosts to see available hosts
- Use --show-trace with nixos-rebuild for detailed error information

Documentation pointers
- README.md: requirements, first-time install methods, upgrade overview
- CLAUDE.md: repository instructions and dcli command reference
- cheatsheets/: quick-reference guides for Hyprland, terminals, editors, etc.

