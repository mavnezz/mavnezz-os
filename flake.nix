{
  description = "mavnezz-os — devices/ layout";

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
  };

  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... } @ inputs:
  let
    system = "x86_64-linux";

    pkgsUnstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

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
      surface = mkWorkstation {
        deviceModule = ./devices/laptop/surface/default.nix;
        inherit hmImports;
      };
      work = mkWorkstation {
        deviceModule = ./devices/desktop/work/default.nix;
        inherit hmImports;
      };
      homework = mkWorkstation {
        deviceModule = ./devices/desktop/homework/default.nix;
        inherit hmImports;
      };
    };
  };
}
