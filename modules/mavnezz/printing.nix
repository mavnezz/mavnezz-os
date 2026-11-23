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
      (pkgs.callPackage ../../pkgs/cups-kyodialog/package.nix { })
      pkgs.cups-dymo # LabelWriter 450 (lw450.ppd) + raster2dymolw filter
    ];
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    services.ipp-usb.enable = true;
    environment.systemPackages = [
      pkgs.system-config-printer
      # Label designer: carries the Dymo 11356 template (41x89mm) among 1759
      # others, plus glabels-batch-qt for printing series from the CLI.
      pkgs.glabels-qt
    ];
  };
}
