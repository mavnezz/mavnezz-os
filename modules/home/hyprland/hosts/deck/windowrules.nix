{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    ;
in {
  # Host-specific window rules for deck
  # These will be merged with the default window rules
  windowrule = [
    # Add deck-specific window rules here
  ];
}
