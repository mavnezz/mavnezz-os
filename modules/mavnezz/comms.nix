# Business and chat communications: Slack, Teams, Zoom, Discord;
# plus remote-desktop clients used at work.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.mavnezz.comms;
in
{
  options.workstation.mavnezz.comms.enable =
    lib.mkEnableOption "Business comms (Slack/Teams/Zoom/Discord) + remote-desktop clients";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "slack"
      "zoom"
      "discord"
      "anydesk"
    ];

    # anydesk's download URL is not versioned, so upstream silently replaced the
    # 8.1.0 tarball and nixpkgs' pinned hash no longer matches. Pin the current
    # tarball hash until nixpkgs catches up, then remove this overlay.
    nixpkgs.overlays = [
      (final: prev: {
        anydesk = prev.anydesk.overrideAttrs (old: {
          src = old.src.overrideAttrs (_: {
            outputHash = "sha256-zS5P2eyTHZY7cBW8mQ2Q6M0lXcx9VZZTtpG3Bb6u7IQ=";
          });
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      slack
      teams-for-linux
      zoom-us
      discord
      remmina
      anydesk
    ];
  };
}
