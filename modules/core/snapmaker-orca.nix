{pkgs, ...}: let
  snapmaker-orca = pkgs.appimageTools.wrapType2 {
    pname = "snapmaker-orca";
    version = "2.2.1";

    src = pkgs.fetchurl {
      url = "https://github.com/Snapmaker/OrcaSlicer/releases/download/v2.2.1/Snapmaker_Orca_Linux_AppImage_Ubuntu2404_V2.2.1_Beta.AppImage";
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
