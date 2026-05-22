{pkgs, ...}: let
  # Bambu Studio - Version 2.4.0
  # To update: change version/tag and sha256, then run dcli rebuild
  # Find latest at: https://github.com/bambulab/BambuStudio/releases
  version = "2.6.0";
  tag = "v02.06.00.51";

  bambu-studio-unwrapped = pkgs.appimageTools.wrapType2 {
    pname = "bambu-studio";
    inherit version;

    src = pkgs.fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/${tag}/BambuStudio_ubuntu-24.04-v02.06.00.51-20260417160415.AppImage";
      sha256 = "0d7pg2lpzgkdw6kbn0q1bybjcya4in3b15z35c07f5bvy9wqz1q9";
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
