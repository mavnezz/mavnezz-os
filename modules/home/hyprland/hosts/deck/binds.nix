{host, ...}: let
  inherit
    (import ../../../../hosts/${host}/variables.nix)
    browser
    terminal
    ;
in {
  # Host-specific binds for deck
  # These will be merged with the default binds
  bind = [
    # Add deck-specific binds here
  ];

  bindm = [
    # Add deck-specific mouse binds here
  ];
}
