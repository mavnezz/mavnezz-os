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
      # Official VS Code, installed system-wide alongside home-manager's
      # VSCodium (same buildEnv would collide). Unlike VSCodium it registers the
      # vscode:// scheme and runs Microsoft's Remote-SSH extension natively.
      # Extensions are baked in: the shared set (same as VSCodium) plus the
      # Remote-SSH trio for the vscode-remote deep links. vscode-with-extensions
      # pins --extensions-dir to the store, so this list is authoritative (add
      # extensions via the repo, not the in-app marketplace).
      (vscode-with-extensions.override {
        vscodeExtensions = (import ../../home/vscode-extensions.nix pkgs) ++ (with vscode-extensions; [
          ms-vscode-remote.remote-ssh
          ms-vscode-remote.remote-ssh-edit
          ms-vscode.remote-explorer
        ]);
      })
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
      nixfmt
    ] ++ [
      pkgs-unstable.claude-code
    ];

    # Reach the dev VM by its .local name for SSH / VS Code Remote-SSH. A
    # networking.hosts (/etc/hosts) entry would NOT work: nss-mdns'
    # "mdns4_minimal [NOTFOUND=return]" intercepts *.local before files is
    # consulted. Pinning it in the system ssh client config sidesteps name
    # resolution entirely and leaves ~/.ssh/config untouched.
    programs.ssh.extraConfig = ''
      Host devvm.local
        HostName 192.168.1.9
        User sirjuls44
    '';
  };
}
