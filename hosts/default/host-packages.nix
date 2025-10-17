{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Add your host-specific packages here
    # Example packages from nixos-leno:
    # audacity
    # discord
    # nodejs
  ];
}
