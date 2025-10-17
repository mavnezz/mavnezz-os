{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    ;
in {
  # Host-specific window rules for homework
  # These will be merged with the default window rules
  windowrule = [
    # Add homework-specific window rules here
  ];
}
