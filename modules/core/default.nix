{inputs, ...}: {
  imports = [
    ./boot.nix
    ./controller-support.nix
    ./flatpak.nix
    ./fonts.nix
    ./sddm.nix
    ./hardware.nix
    ./network.nix
    ./nfs.nix
    ./nh.nix
    ./packages.nix
    ./printing.nix
    ./security.nix
    ./services.nix
    ./bambu-studio.nix
    ./snapmaker-orca.nix
    ./starfish.nix
    ./steam.nix
    ./stylix.nix
    ./syncthing.nix
    ./system.nix
    ./user.nix
    ./virtualisation.nix
    ./xserver.nix
    inputs.stylix.nixosModules.stylix
  ];
}
