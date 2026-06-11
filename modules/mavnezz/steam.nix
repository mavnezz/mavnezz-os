# Steam with gamescope, Proton GE, controller support kernel modules,
# and udev rules for Switch Pro / Joy-Con / Xbox controllers.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.mavnezz.steam;
in
{
  options.workstation.mavnezz.steam.enable =
    lib.mkEnableOption "Steam + gamescope + game controller support";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
      "steam-original"
      "steam-run"
    ];

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];

      package = pkgs.steam.override {
        extraPkgs = p: with p; [
          libusb1 udev SDL2
          xorg.libXcursor xorg.libXi xorg.libXinerama xorg.libXScrnSaver
        ];
      };
    };

    programs.gamescope = {
      enable = true;
      capSysNice = true;
      args = [ "--rt" "--expose-wayland" ];
    };

    # Controller kernel modules + udev rules
    boot.kernelModules = [ "uinput" "hid_nintendo" "xpad" ];
    boot.kernelParams = [
      "usbhid.quirks=0x057e:0x2009:0x80000000"  # Switch Pro Controller fix
    ];

    hardware.steam-hardware.enable = true;
    hardware.xpadneo.enable = true;

    services.udev.extraRules = ''
      # Nintendo Switch Pro Controller (USB + Bluetooth)
      KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", KERNELS=="*057E:2009*", MODE="0666", TAG+="uaccess"
      SUBSYSTEM=="input", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", ENV{ID_INPUT_JOYSTICK}=="1", TAG+="steam-controller"
      SUBSYSTEM=="input", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", ENV{ID_INPUT_JOYSTICK}=="1", ENV{STEAM_INPUT_ENABLE}="1"
      SUBSYSTEM=="input", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2009", ENV{ID_INPUT_JOYSTICK}=="1", RUN+="${pkgs.coreutils}/bin/chmod 666 /dev/input/event%n"

      # Nintendo Switch Joy-Cons + Charging Grip
      KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2006", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", KERNELS=="*057E:2006*", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="2007", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", KERNELS=="*057E:2007*", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="200e", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", KERNELS=="*057E:200E*", MODE="0666", TAG+="uaccess"

      # Xbox One / Series X|S / 360
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02ea", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b00", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b05", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b12", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b13", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b20", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b21", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="0b22", MODE="0666", TAG+="uaccess"
      KERNEL=="hidraw*", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", MODE="0666", TAG+="uaccess"

      # Generic catch-all
      SUBSYSTEM=="input", ATTRS{name}=="*Controller*", MODE="0666", TAG+="uaccess"
      SUBSYSTEM=="input", ATTRS{name}=="*Gamepad*", MODE="0666", TAG+="uaccess"
      SUBSYSTEM=="input", ATTRS{name}=="*Joy-Con*", MODE="0666", TAG+="uaccess"
    '';

    environment.systemPackages = with pkgs; [
      SDL2
      jstest-gtk
      evtest
      antimicrox
    ];
  };
}
