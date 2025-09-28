{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.nwg-drawer-stylix;
in {
  options.services.nwg-drawer-stylix = {
    enable = mkEnableOption "nwg-drawer with stylix theming";
  };

  config = mkIf cfg.enable {
    xdg.configFile."nwg-drawer/drawer.css".text = with config.lib.stylix.colors; ''
      window {
        background-color: rgba(${toString (lib.fromHexString (builtins.substring 0 2 base00))}, ${toString (lib.fromHexString (builtins.substring 2 2 base00))}, ${toString (lib.fromHexString (builtins.substring 4 2 base00))}, 0.9);
        color: #${base05};
        font-family: "${config.stylix.fonts.sansSerif.name}";
        font-size: ${toString config.stylix.fonts.sizes.applications}pt;
      }

      #searchbox {
        background-color: #${base01};
        border: 2px solid #${base03};
        color: #${base05};
        border-radius: 6px;
        padding: 8px;
        margin: 10px;
      }

      #searchbox:focus {
        border-color: #${base0D};
      }

      button {
        background-color: transparent;
        border: none;
        color: #${base05};
        padding: 8px;
        border-radius: 6px;
        margin: 2px;
      }

      button:hover {
        background-color: #${base02};
      }

      button:focus, button:active {
        background-color: #${base03};
      }

      .category-label {
        color: #${base0D};
        font-weight: bold;
        padding: 10px;
      }

      .app-name {
        color: #${base05};
      }

      .app-comment {
        color: #${base04};
        font-size: smaller;
      }

      scrolledwindow {
        background-color: transparent;
      }

      .file-item {
        color: #${base05};
      }

      .file-item:hover {
        background-color: #${base02};
      }
    '';
  };
}
