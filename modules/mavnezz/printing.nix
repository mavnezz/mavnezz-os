# CUPS printing + Avahi mDNS for network printer discovery + ipp-usb for
# IPP-over-USB printers.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.mavnezz.printing;
in
{
  options.workstation.mavnezz.printing.enable =
    lib.mkEnableOption "CUPS printing + Avahi discovery + ipp-usb";

  config = lib.mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = [
      # add manufacturer-specific drivers here when needed (e.g. pkgs.hplipWithPlugin)
    ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    services.ipp-usb.enable = true;
    environment.systemPackages = [ pkgs.system-config-printer ];
  };
}
