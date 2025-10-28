{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    extraMonitorSettings
    ;
in {
  # Host-specific window rules for surface
  # These will be merged with the default window rules
  windowrule = [
    # Add surface-specific window rules here
  ];
}
