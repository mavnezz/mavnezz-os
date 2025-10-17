{...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Enable ly display manager by default
  services.displayManager.ly.enable = true;
}
