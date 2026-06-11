# Media editing + playback + audio control. hyprpicker is a Wayland color
# picker that works under Niri via xdg-desktop-portal-wlr.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.mavnezz.media;
in
{
  options.workstation.mavnezz.media.enable =
    lib.mkEnableOption "Media editing, playback, and audio control";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gimp
      vlc
      ffmpeg
      sox
      libreoffice
      pavucontrol
      playerctl
      hyprpicker
    ];
  };
}
