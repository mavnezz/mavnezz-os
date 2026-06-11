# YubiKey OATH GUI client. pcscd is already enabled by sensei's
# baseline.nix, so we only need the OATH frontend here.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.mavnezz.security;
in
{
  options.workstation.mavnezz.security.enable =
    lib.mkEnableOption "YubiKey OATH client";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.yubioath-flutter ];
  };
}
