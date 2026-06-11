# Syncthing for the primary user. The user account is hardcoded to
# sirjuls44 (matches baseline.nix); change here if a host runs Syncthing
# under a different user.
{
  config,
  lib,
  ...
}:
let
  cfg = config.workstation.mavnezz.syncthing;
  user = "sirjuls44";
in
{
  options.workstation.mavnezz.syncthing.enable =
    lib.mkEnableOption "Syncthing for ${user}";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      user = user;
      dataDir = "/home/${user}";
      configDir = "/home/${user}/.config/syncthing";
    };
  };
}
