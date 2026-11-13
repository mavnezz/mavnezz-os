# Open-source, clean-room office/creative apps written in pure Rust.
#
# The storytold "Craft" suite lives in nixpkgs-unstable (not yet in 26.05
# stable), so those come from the pkgs-unstable input. SolidCraft is not in
# nixpkgs at all but ships its own flake, consumed via the solidcraft input.
# Both are forwarded via specialArgs by the flake.
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
let
  cfg = config.workstation.mavnezz.craftApps;
in
{
  options.workstation.mavnezz.craftApps.enable =
    lib.mkEnableOption "Craft office suite, PhotoCraft and SolidCraft";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = (with pkgs-unstable; [
      wordcraft # Word
      gridcraft # Excel
      deckcraft # PowerPoint
      pdfcraft # PDF reader/editor
      photocraft # Photoshop
    ]) ++ [
      # Parametric 3D CAD (Fusion/SolidWorks-like), built from its own flake.
      inputs.solidcraft.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}
