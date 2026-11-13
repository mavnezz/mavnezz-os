# ArtCraft "Craft" apps (storytold) — clean-room office/creative apps written
# in pure Rust. They live in nixpkgs-unstable (not yet in 26.05 stable), so
# they come from the pkgs-unstable input forwarded via specialArgs.
{
  config,
  lib,
  pkgs-unstable,
  ...
}:
let
  cfg = config.workstation.mavnezz.craftApps;
in
{
  options.workstation.mavnezz.craftApps.enable =
    lib.mkEnableOption "ArtCraft office suite + PhotoCraft";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs-unstable; [
      wordcraft # Word
      gridcraft # Excel
      deckcraft # PowerPoint
      pdfcraft # PDF reader/editor
      photocraft # Photoshop
    ];
  };
}
