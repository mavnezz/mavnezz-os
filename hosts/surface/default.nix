{inputs, ...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];

  # Enable surface-specific features
  microsoft-surface.ipts.enable = true;
  microsoft-surface.surface-control.enable = true;
}
