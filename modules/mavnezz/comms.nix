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
