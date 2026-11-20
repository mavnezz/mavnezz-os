# MailCraft: open-source email client (IMAP/SMTP, POP3, JMAP, Microsoft 365/
# Exchange, CalDAV/CardDAV), a sibling of the Craft apps. Not in nixpkgs yet,
# so this repackages the prebuilt upstream release tarball. For a new release,
# bump `version` and `hash` (SHA256SUMS.txt on the release page).
{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  dbus,
  fontconfig,
  libGL,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxkbcommon,
  libxrandr,
  vulkan-loader,
  wayland,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mailcraft";
  version = "0.40.0";

  src = fetchurl {
    url = "https://github.com/ZIDAN44/mailcraft/releases/download/v${finalAttrs.version}/mailcraft-${finalAttrs.version}-linux-x86_64.tar.gz";
    hash = "sha256-K4oTI40amUF7OVSezSqGzYpQenusyarQVF5t/3pziow=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ stdenv.cc.cc.lib ];

  # The binaries only link libc/libgcc; winit, wgpu and the keyring code load
  # the rest with dlopen, so autoPatchelf adds these to the RPATH.
  runtimeDependencies = map lib.getLib [
    dbus
    fontconfig
    libGL
    libx11
    libxcb
    libxcursor
    libxi
    libxkbcommon
    libxrandr
    vulkan-loader
    wayland
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r bin share $out/
    runHook postInstall
  '';

  # The built-in updater can't replace files in the Nix store.
  postFixup = ''
    wrapProgram $out/bin/mailcraft --set MAILCRAFT_NO_AUTO_UPDATE 1
  '';

  meta = {
    description = "Open-source, local-first email client with calendar and contacts";
    homepage = "https://mailcraft.dev";
    changelog = "https://github.com/ZIDAN44/mailcraft/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mailcraft";
  };
})
