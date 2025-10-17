{lib, ...}: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  # Enable SDDM display manager
  services.greetd.enable = lib.mkForce false;
  services.displayManager.ly.enable = false;
  services.displayManager.sddm.enable = true;
}
