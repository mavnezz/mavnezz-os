{
  description = "Black Don OS — sensei-style devices/ layout";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    flake-utils.url = "github:numtide/flake-utils";

    # Legacy inputs kept during the transition. Will be removed in the
    # Phase F cleanup commit once the new configs are confirmed building.
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.11";
    vicinae.url = "github:vicinaehq/vicinae/24a71cac107f9b42f70ec2015e41ef02f617b1f1";
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, flake-utils, ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    # Legacy helper — used by the hosts/* configs during the transition.
    mkHost = { hostname, profile, username }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        host = hostname;
        inherit profile;
        inherit username;
        pkgs-unstable = pkgsUnstable;
      };
      modules = [ ./profiles/${profile} ];
    };

    # New sensei-style factory for the devices/ layout.
    mkWorkstation = { deviceModule, hmImports }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        pkgs-unstable = pkgsUnstable;
      };
      modules = [
        deviceModule
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            extraSpecialArgs = {
              inherit inputs;
              pkgs-unstable = pkgsUnstable;
            };
            sharedModules = [
              ({ osConfig, ... }: {
                _module.args.hostName = osConfig.networking.hostName;
              })
            ];
            users.sirjuls44 = { imports = hmImports; };
          };
        }
      ];
    };

    hmImports = [
      ./home/common.nix
      ./home/zsh.nix
      ./home/niri.nix
      ./home/vscode.nix
      ./home/scripts
    ];

  in {
    nixosConfigurations = {
      # ---------------- Legacy (hosts/*) — keep building during transition ----------------
      amd           = mkHost { hostname = "default"; profile = "amd";           username = "user"; };
      nvidia        = mkHost { hostname = "default"; profile = "nvidia";        username = "user"; };
      nvidia-laptop = mkHost { hostname = "default"; profile = "nvidia-laptop"; username = "user"; };
      intel         = mkHost { hostname = "default"; profile = "intel";         username = "user"; };
      vm            = mkHost { hostname = "default"; profile = "vm";            username = "user"; };
      default       = mkHost { hostname = "default"; profile = "nvidia-laptop"; username = "user"; };
      surface       = mkHost { hostname = "surface";  profile = "intel"; username = "sirjuls44"; };
      homework      = mkHost { hostname = "homework"; profile = "intel"; username = "sirjuls44"; };
      work          = mkHost { hostname = "work";     profile = "intel"; username = "sirjuls44"; };

      # ---------------- New (devices/*) — test via `nixos-rebuild build .#<n>-new` ----------------
      surface-new = mkWorkstation {
        deviceModule = ./devices/laptop/surface/default.nix;
        inherit hmImports;
      };
      work-new = mkWorkstation {
        deviceModule = ./devices/desktop/work/default.nix;
        inherit hmImports;
      };
      homework-new = mkWorkstation {
        deviceModule = ./devices/desktop/homework/default.nix;
        inherit hmImports;
      };
    };

    # Flutter dev shell — kept conditional on the legacy hosts/default during transition.
    # Will be simplified or moved to a workstation.flutter.enable flag in cleanup.
    devShells = flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs-unstable {
          inherit system;
          config = {
            android_sdk.accept_license = true;
            allowUnfree = true;
          };
        };
        buildToolsVersion = "33.0.2";
        androidComposition = pkgs.androidenv.composeAndroidPackages {
          buildToolsVersions = [ buildToolsVersion ];
          platformVersions = [ "33" ];
          abiVersions = [ "arm64-v8a" ];
        };
        androidSdk = androidComposition.androidsdk;

        hostHasFlutter = hostname:
          let
            hostVars = import ./hosts/${hostname}/variables.nix;
          in
            hostVars.flutterdevEnable or false;

        flutterShell = with pkgs; mkShell rec {
          ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
          buildInputs = [
            flutter
            androidSdk
            jdk11
          ];
        };
      in
      {
        default = if (hostHasFlutter "default")
                  then flutterShell
                  else pkgs.mkShell { buildInputs = []; };
      });
  };
}
