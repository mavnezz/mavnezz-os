# Browsers: Google Chrome only, set as the default browser.
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
    lib.mkEnableOption "Web browser (Google Chrome, set as default)";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "google-chrome"
    ];

    environment.systemPackages = [ pkgs.google-chrome ];

    # System-wide default (/etc/xdg/mimeapps.list); ~/.config/mimeapps.list
    # stays writable and still wins for any key it sets.
    xdg.mime.defaultApplications = lib.genAttrs [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/about"
      "x-scheme-handler/unknown"
    ] (_: "google-chrome.desktop");
  };
}
