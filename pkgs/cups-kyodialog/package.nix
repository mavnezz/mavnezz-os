# Kyocera CUPS driver (kyodialog) 10.1, built from the EU amd64 .deb in
# KyoceraLinuxPackages-20260709.tar.gz. nixpkgs only ships 9.4, which needs
# pypdf3 (marked insecure); 10.1 runs its pre-filter on pypdf instead.
# Based on pkgs/by-name/cu/cups-kyodialog in nixpkgs.
{
  lib,
  stdenv,
  autoPatchelfHook,
  python3Packages,
  cups,
  zlib,
  dbus,
}:

let
  kyodialog_version = "10.1";
in
stdenv.mkDerivation rec {
  pname = "cups-kyodialog";
  version = kyodialog_version;

  src = ./kyodialog_10.1-0_amd64.deb;

  dontStrip = true;

  sourceRoot = ".";
  unpackCmd = "ar p $src data.tar.gz | tar -xz";

  nativeBuildInputs = [
    autoPatchelfHook
    python3Packages.wrapPython
  ];

  buildInputs = [
    cups
    zlib
    dbus
  ];

  # for lib/cups/filter/kyofilter_pre_X
  propagatedBuildInputs = with python3Packages; [
    pypdf
    reportlab
  ];

  installPhase = ''
    runHook preInstall

    # allow cups to find the ppd files
    mkdir -p $out/share/cups/model
    mv ./usr/share/kyocera${kyodialog_version}/ppd${kyodialog_version} $out/share/cups/model/Kyocera

    # remove absolute path prefixes to filters in ppd
    find $out -name "*.ppd" -exec sed -E -i "s:/usr/lib/cups/filter/::g" {} +

    mkdir -p $out/lib/cups
    mv ./usr/lib/cups/filter $out/lib/cups/
    wrapPythonProgramsIn $out/lib/cups/filter "$propagatedBuildInputs"

    install -Dm444 usr/share/doc/kyodialog/copyright $out/share/doc/${pname}/copyright

    runHook postInstall
  '';

  meta = {
    description = "CUPS drivers for several Kyocera printers";
    homepage = "https://www.kyoceradocumentsolutions.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
  };
}
