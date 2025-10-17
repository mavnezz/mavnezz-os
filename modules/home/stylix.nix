{
  host,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) stylixEnable;
in
lib.mkIf stylixEnable {
  stylix.targets = {
    waybar.enable = false;
    rofi.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    qt.enable = false;
  };
}
