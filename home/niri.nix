{
  config,
  pkgs,
  lib,
  hostName,
  ...
}:
let
  niriConfig = if hostName == "surface"
    then ../config/niri/config.laptop.kdl
    else ../config/niri/config.desktop.kdl;
  niriOutputs = ../config/niri + "/outputs.${hostName}.kdl";
in
{
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };

    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    gtk3.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
    };

    gtk4.extraConfig = {
      "gtk-application-prefer-dark-theme" = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "Fusion";
  };

  xdg.configFile = {
    "gtk-3.0/settings.ini".force = true;
    "gtk-4.0/settings.ini".force = true;
    "gtk-4.0/gtk.css".force = true;
    "niri/config.kdl".source = niriConfig;
    "niri/outputs.kdl".source = niriOutputs;
    "niri/noctalia.kdl".source = ../config/niri/noctalia.kdl;
    "ghostty/config".source = ../config/ghostty/tokyo-night.ghostty;
  };

  home.pointerCursor = {
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_THEME = "BreezeX-RosePine-Linux";
    XCURSOR_SIZE = "24";
    NIXOS_OZONE_WL = "1";
    ICON_THEME = "Papirus";
    QS_ICON_THEME = "Papirus";
  };

  # Seed Noctalia settings on first activation. Noctalia writes back to this file
  # when the user changes things in the in-shell settings UI, so we only copy if
  # the user file does not yet exist — keeping the repo version as the default
  # without clobbering live UI changes.
  home.activation.seedNoctaliaSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    target="$HOME/.local/state/noctalia/settings.toml"
    if [ ! -e "$target" ]; then
      $DRY_RUN_CMD install -Dm644 ${../config/noctalia/settings.toml} "$target"
    fi
  '';
}
