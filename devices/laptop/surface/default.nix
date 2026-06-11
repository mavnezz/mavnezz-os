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

  networking.hostName = "surface";
  system.stateVersion = "23.11";

  workstation = {
    baseline = {
      enable = true;
      packages = {
        tools = true;
        dev = false;   # mavnezz.dev covers the dev stack
        apps = false;  # mavnezz.{comms,browsers,media,security} cover apps
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
      steam.enable      = false;  # portable laptop, no gaming
      syncthing.enable  = false;
    };
  };

  # Git identity for the user
  home-manager.users.sirjuls44.programs.git.settings.user = {
    name  = vars.gitUsername;
    email = vars.gitEmail;
  };

  # 8 GiB swapfile (matches existing per-host swap config)
  swapDevices = lib.mkDefault [
    { device = "/swapfile"; size = 8192; }
  ];
}
