{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    browser
    terminal
    ;
in {
  # Host-specific binds for surface
  # These will be merged with the default binds
  bind = [
    # Add surface-specific binds here
  ];

  bindm = [
    # Add surface-specific mouse binds here
  ];
}
