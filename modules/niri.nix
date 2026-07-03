{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.workstation.niri;
in
{
  options.workstation.niri.enable = lib.mkEnableOption "Niri-based workstation environment with Noctalia Shell";

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;

    services.gvfs.enable = true;

    qt = {
      enable = true;
    };

    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      xwayland-satellite
      tokyonight-gtk-theme
      swayimg
      rose-pine-cursor
      papirus-icon-theme
      nemo
      gpu-screen-recorder
      wl-clipboard
      libsForQt5.qt5ct
      mpvpaper
    ];

    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --cmd niri-session";
          user = "greeter";
        };
      };
    };

    # Plymouth graphical boot splash — hides kernel/systemd messages so they
    # don't leak into tuigreet's TUI when greetd takes over the tty.
    boot = {
      plymouth.enable = true;
      kernelParams = [
        "quiet"
        "splash"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];
      consoleLogLevel = 0;
      initrd.verbose = false;
    };
  };
}
