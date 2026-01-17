{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Add your host-specific packages here
    # Host-specific packages:
    # audacity
    # discord
    # nodejs
  ];
}
