# greetd - minimal login manager with tuigreet
{pkgs, config, ...}: let
  scheme = config.stylix.base16Scheme;
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --greeting 'Welcome' --theme 'border=#${scheme.base0D};text=#${scheme.base05};prompt=#${scheme.base0E};time=#${scheme.base04};action=#${scheme.base0C};button=#${scheme.base0D};container=#${scheme.base01};input=#${scheme.base05}' --cmd Hyprland";
        user = "greeter";
      };
    };
  };
}
