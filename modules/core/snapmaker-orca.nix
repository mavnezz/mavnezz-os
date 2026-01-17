{pkgs, ...}: let
  # Snapmaker OrcaSlicer - Version 2.2.1
  # To update: change version and sha256, then run dcli rebuild
  # Find latest at: https://github.com/Snapmaker/OrcaSlicer/releases
  version = "2.2.1";

  snapmaker-orca = pkgs.appimageTools.wrapType2 {
    pname = "snapmaker-orca";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/Snapmaker/OrcaSlicer/releases/download/v${version}/Snapmaker_Orca_Linux_AppImage_Ubuntu2404_V${version}_Beta.AppImage";
      sha256 = "0lcl4zm5kvq5fhm6fklcrmhsqaykhjz3ns0jwd9w3321fcz1cmck";
    };

    extraPkgs = pkgs: with pkgs; [
      webkitgtk_4_1
      glib
      glib-networking
      gtk3
      libsoup_3
    ];
  };
in {
  environment.systemPackages = [snapmaker-orca];

  # Desktop Entry
  xdg.mime.enable = true;
}
