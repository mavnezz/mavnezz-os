{
  config,
  lib,
  pkgs,
  ...
}:
let
  vars = import ./variables.nix;
in
{
  imports = [
    ./hardware.nix
    ../../../modules/baseline.nix
    ../../../modules/niri.nix
    ../../../modules/packages.nix
    ../../../modules/virtualization.nix
    ../../../modules/polkit.nix
    ../../../modules/mount.nix
    ../../../modules/gpu
    ../../../modules/mavnezz
  ];

  networking.hostName = "homework";
  system.stateVersion = "23.11";

  workstation = {
    baseline = {
      enable = true;
      packages = {
        tools = true;
        dev = false;
        apps = false;
      };
    };

    niri.enable = true;
    polkit.enable = true;
    virtualization.enable = true;
    gpu.intel.enable = true;

    mavnezz = {
      printers3d.enable = true;
      printing.enable   = false;
      dev.enable        = true;
      comms.enable      = true;
      browsers.enable   = true;
      media.enable      = true;
      security.enable   = true;
      steam.enable      = true;   # private workstation, gaming OK
      syncthing.enable  = false;
    };
  };

  home-manager.users.sirjuls44.programs.git.settings.user = {
    name  = vars.gitUsername;
    email = vars.gitEmail;
  };

  swapDevices = lib.mkDefault [
    { device = "/swapfile"; size = 8192; }
  ];
}
