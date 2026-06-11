# Bambu Studio + Snapmaker OrcaSlicer as upstream-provided AppImages,
# rewrapped via appimageTools so they run on NixOS with the right libs.
# Update via the scripts under scripts/update-{bambu-studio,snapmaker-orca}.sh.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.mavnezz.printers3d;

  bambuVersion = "2.6.0";
  bambuTag = "v02.06.00.51";
  bambu-studio-unwrapped = pkgs.appimageTools.wrapType2 {
    pname = "bambu-studio";
    version = bambuVersion;
    src = pkgs.fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/${bambuTag}/BambuStudio_ubuntu-24.04-v02.06.00.51-20260417160415.AppImage";
      sha256 = "0d7pg2lpzgkdw6kbn0q1bybjcya4in3b15z35c07f5bvy9wqz1q9";
    };
    extraPkgs = p: with p; [
      webkitgtk_4_1 glib glib-networking gtk3 libsoup_3
      openssl cacert curl nss nspr
    ];
  };
  bambu-studio = pkgs.writeShellScriptBin "bambu-studio" ''
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules"
    exec ${bambu-studio-unwrapped}/bin/bambu-studio "$@"
  '';

  snapmakerVersion = "2.3.0";
  snapmaker-orca-unwrapped = pkgs.appimageTools.wrapType2 {
    pname = "snapmaker-orca";
    version = snapmakerVersion;
    src = pkgs.fetchurl {
      url = "https://github.com/Snapmaker/OrcaSlicer/releases/download/v${snapmakerVersion}/Snapmaker_Orca_Linux_AppImage_Ubuntu2404_V${snapmakerVersion}_Beta.AppImage";
      sha256 = "16xhv34gbi6w6i9asjw80w866yscd94qfkm46ysxx1ak1vf6wryk";
    };
    extraPkgs = p: with p; [
      webkitgtk_4_1 glib glib-networking gtk3 libsoup_3
      openssl cacert curl nss nspr
    ];
  };
  snapmaker-orca = pkgs.writeShellScriptBin "snapmaker-orca" ''
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules"
    exec ${snapmaker-orca-unwrapped}/bin/snapmaker-orca "$@"
  '';
in
{
  options.workstation.mavnezz.printers3d.enable =
    lib.mkEnableOption "Bambu Studio + Snapmaker OrcaSlicer for 3D printing";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ bambu-studio snapmaker-orca ];
    xdg.mime.enable = true;
  };
}
