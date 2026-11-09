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

  networking.hostName = "work";
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
      printing.enable   = true;
      dev.enable        = true;
      comms.enable      = true;
      browsers.enable   = true;
      media.enable      = true;
      security.enable   = true;
      steam.enable      = true;
      syncthing.enable  = false;
    };
  };

  # Kyocera TASKalfa 3554ci: IPP on the device answers "service unavailable",
  # so it is driven over raw port 9100 with the kyodialog PPD.
  hardware.printers = {
    ensurePrinters = [
      {
        name = "TASKalfa_3554ci";
        description = "Kyocera TASKalfa 3554ci";
        deviceUri = "socket://192.168.0.15:9100";
        model = "Kyocera/Kyocera_TASKalfa_3554ci.ppd";
        ppdOptions = {
          PageSize = "A4";
          Duplex = "None";
        };
      }
    ];
    ensureDefaultPrinter = "TASKalfa_3554ci";
  };

  home-manager.users.sirjuls44.programs.git.settings.user = {
    name  = vars.gitUsername;
    email = vars.gitEmail;
  };

}
