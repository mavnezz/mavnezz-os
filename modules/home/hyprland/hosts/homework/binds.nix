{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    browser
    terminal
    ;
in {
  # Host-specific binds for homework
  # These will be merged with the default binds
  bind = [
    # Add homework-specific binds here
  ];

  bindm = [
    # Add homework-specific mouse binds here
  ];
}
