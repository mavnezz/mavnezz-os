{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mount;
in
{
  options.mount = {
    games.enable = lib.mkEnableOption "Local mount for storing video game files";
    media.enable = lib.mkEnableOption "Local media mount for Jellyfin, Kavita, Immich, and Navidrome";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.games.enable {
      fileSystems."/mnt/games" = {
        device = "/dev/disk/by-uuid/7b2f5538-ff2f-44a7-9a7e-105bf75d6c70";
        fsType = "ext4";
        options = [
          "nosuid"
          "nodev"
          "noatime"
          "nofail"
        ];
      };
    })

    (lib.mkIf cfg.media.enable {
      fileSystems."/mnt/jelly" = {
        device = "/dev/disk/by-uuid/928958de-b7ae-4310-9465-57377da78508";
        fsType = "ext4";
        options = [
          "nosuid"
          "nodev"
          "noatime"
          "nofail"
        ];
      };
    })
  ];
}
