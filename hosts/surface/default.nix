{inputs, ...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    inputs.nixos-hardware.nixosModules.microsoft-surface-pro-intel
  ];
}
