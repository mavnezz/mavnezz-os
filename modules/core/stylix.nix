{
  pkgs,
  host,
  lib,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) stylixEnable stylixImage;
in
lib.mkIf stylixEnable {
  # Styling Options
  stylix = {
    enable = true;
    # Manual dark color scheme (no wallpaper)
    #base16Scheme = {
    #base00 = "000000";  # Pure black background
    #base01 = "1a1a1a";  # Dark gray
    #base02 = "2a2a2a";  # Lighter gray
    #base03 = "3a3a3a";  # Medium gray
    #base04 = "6a6a6a";  # Light gray
    #base05 = "d0d0d0";  # Very light gray (text)
    #base06 = "e0e0e0";  # Almost white
    #base07 = "ffffff";  # Pure white
    #base08 = "8c9440";  # Muted green (errors/delete)
    #base09 = "de935f";  # Muted orange (warnings)
    #base0A = "f0c674";  # Muted yellow (search)
    #base0B = "b5bd68";  # Muted green (strings/added)
    #base0C = "8abeb7";  # Muted cyan (regex/escape)
    #base0D = "81a2be";  # Muted blue (functions)
    #base0E = "b294bb";  # Muted purple (keywords)
    #base0F = "a3685a";  # Muted brown (deprecated)
    #};
    image = stylixImage;
    polarity = "dark";
    opacity.terminal = 1.0;
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrains Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };
}
