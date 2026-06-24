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

  mkSlicer = { pname, version, desktopName, src }: let
    unwrapped = pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraPkgs = p: with p; [
        webkitgtk_4_1 glib glib-networking gtk3 libsoup_3
        openssl cacert curl nss nspr
      ];
    };
    extracted = pkgs.appimageTools.extract { inherit pname version src; };
    wrapper = pkgs.writeShellScriptBin pname ''
      export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules"
      exec ${unwrapped}/bin/${pname} "$@"
    '';
    desktopItem = pkgs.makeDesktopItem {
      name = pname;
      inherit desktopName;
      exec = "${pname} %F";
      icon = pname;
      categories = [ "Graphics" "3DGraphics" ];
      mimeTypes = [ "model/3mf" "model/stl" "model/obj" "application/vnd.ms-3mfdocument" ];
    };
  in pkgs.symlinkJoin {
    name = "${pname}-${version}";
    paths = [ wrapper desktopItem ];
    postBuild = ''
      for f in "${extracted}"/*.png "${extracted}"/*.svg \
               "${extracted}"/usr/share/icons/hicolor/256x256/apps/*.png; do
        if [ -f "$f" ]; then
          ext="''${f##*.}"
          install -Dm644 "$f" "$out/share/icons/hicolor/256x256/apps/${pname}.$ext"
          break
        fi
      done
    '';
  };

  bambu-studio = mkSlicer {
    pname = "bambu-studio";
    version = "2.6.0";
    desktopName = "Bambu Studio";
    src = pkgs.fetchurl {
      url = "https://github.com/bambulab/BambuStudio/releases/download/v02.06.00.51/BambuStudio_ubuntu-24.04-v02.06.00.51-20260417160415.AppImage";
      sha256 = "0d7pg2lpzgkdw6kbn0q1bybjcya4in3b15z35c07f5bvy9wqz1q9";
    };
  };

  snapmaker-orca = mkSlicer {
    pname = "snapmaker-orca";
    version = "2.3.0";
    desktopName = "Snapmaker Orca";
    src = pkgs.fetchurl {
      url = "https://github.com/Snapmaker/OrcaSlicer/releases/download/v2.3.0/Snapmaker_Orca_Linux_AppImage_Ubuntu2404_V2.3.0_Beta.AppImage";
      sha256 = "16xhv34gbi6w6i9asjw80w866yscd94qfkm46ysxx1ak1vf6wryk";
    };
  };
in
{
  options.workstation.mavnezz.printers3d.enable =
    lib.mkEnableOption "Bambu Studio + Snapmaker OrcaSlicer for 3D printing";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ bambu-studio snapmaker-orca ];
    xdg.mime.enable = true;
  };
}
