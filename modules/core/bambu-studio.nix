{pkgs, ...}: let
  # Bambu Studio - Version 2.4.0
  # To update: change version/tag and sha256, then run dcli rebuild
  # Find latest at: https://github.com/bambulab/BambuStudio/releases
  version = "2.4.0";
  tag = "v02.04.00.70";

  bambu-studio = pkgs.appimageTools.wrapType2 {
    pname = "bambu-studio";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/${tag}/Bambu_Studio_ubuntu-24.04_PR-8834.AppImage";
      sha256 = "1gfyy7yxgxgn8ica24kkw931q809cmva60qy5d32xpq4rgf0gg16";
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
  environment.systemPackages = [bambu-studio];

  # Desktop Entry
  xdg.mime.enable = true;
}
