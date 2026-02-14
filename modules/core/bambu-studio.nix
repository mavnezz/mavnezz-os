{pkgs, ...}: let
  # Bambu Studio - Version 2.4.0
  # To update: change version/tag and sha256, then run dcli rebuild
  # Find latest at: https://github.com/bambulab/BambuStudio/releases
  version = "2.5.0";
  tag = "v02.05.00.67";

  bambu-studio-unwrapped = pkgs.appimageTools.wrapType2 {
    pname = "bambu-studio";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/${tag}/Bambu_Studio_ubuntu-24.04_PR-9540.AppImage";
      sha256 = "1y2rciq5hid7g51wq8z73rl0ma49n0l45y4xsvrrqf7cb9pdkrny";
    };

    extraPkgs = pkgs: with pkgs; [
      webkitgtk_4_1
      glib
      glib-networking
      gtk3
      libsoup_3
      openssl
      cacert
      curl
      nss
      nspr
    ];
  };

  bambu-studio = pkgs.writeShellScriptBin "bambu-studio" ''
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules"
    exec ${bambu-studio-unwrapped}/bin/bambu-studio "$@"
  '';
in {
  environment.systemPackages = [bambu-studio];

  # Desktop Entry
  xdg.mime.enable = true;
}
