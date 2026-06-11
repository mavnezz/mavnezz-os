# Development stack: .NET 10, PHP 8.3 + Composer, Node.js, Python 3 with
# extras, PlatformIO inside an FHS env (pip-friendly), Azure CLI with
# devops extension, plus generic dev convenience tools.
#
# `pkgs-unstable` is forwarded via specialArgs by the flake; used for
# `claude-code` which moves fast and lives on unstable.
{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}:
let
  cfg = config.workstation.mavnezz.dev;

  platformio-fhs = pkgs.buildFHSEnv {
    name = "platformio";
    targetPkgs = p: with p; [
      platformio-core python3 python3Packages.pip python3Packages.setuptools zlib libusb1
    ];
    runScript = "platformio";
  };
  pio-fhs = pkgs.buildFHSEnv {
    name = "pio";
    targetPkgs = p: with p; [
      platformio-core python3 python3Packages.pip python3Packages.setuptools zlib libusb1
    ];
    runScript = "pio";
  };
  platformio = pkgs.symlinkJoin {
    name = "platformio-fhs";
    paths = [ platformio-fhs pio-fhs ];
  };
in
{
  options.workstation.mavnezz.dev.enable =
    lib.mkEnableOption "Development toolchain (.NET, PHP, Node, Python, PlatformIO, Azure, Claude Code)";

  config = lib.mkIf cfg.enable {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "vscode-extension-ms-dotnettools-csharp"
      "claude"
    ];

    environment.systemPackages = with pkgs; [
      # .NET
      dotnet-sdk_10
      # PHP / Laravel
      php83
      php83Packages.composer
      # Node
      nodejs
      # Python with the packages the user reaches for
      (python3.withPackages (ps: with ps; [ requests configobj ]))
      # IoT / ESP32
      platformio
      # Cloud
      (azure-cli.withExtensions [ azure-cli.extensions.azure-devops ])
      # Container ergonomics
      docker-compose
      lazydocker
      # Git ergonomics
      lazygit
      gh
      # Build / run helpers
      just
      pkg-config
      # Nix LSP / formatter
      nixd
      nil
      nixfmt-rfc-style
    ] ++ [
      pkgs-unstable.claude-code
    ];
  };
}
