# Browsers: Chromium (open), Google Chrome (mandatory for some work tools),
# Vivaldi (preferred daily driver).
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.mavnezz.browsers;
in
{
  options.workstation.mavnezz.browsers.enable =
    lib.mkEnableOption "Web browsers (Chromium, Google Chrome, Vivaldi)";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "google-chrome"
      "vivaldi"
    ];

    environment.systemPackages = with pkgs; [
      chromium
      google-chrome
      vivaldi
    ];
  };
}
