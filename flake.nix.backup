{
  description = "Black Don OS (Based on ZaneyOS)";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    vicinae.url = "github:vicinaehq/vicinae/24a71cac107f9b42f70ec2015e41ef02f617b1f1";
  };

  outputs = {nixpkgs, nixpkgs-unstable, flake-utils, ...} @ inputs: let
    system = "x86_64-linux";

    # Helper function to create a host configuration
    mkHost = {hostname, profile, username}: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        host = hostname;
        inherit profile;
        inherit username;
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };
      modules = [./profiles/${profile}];
    };

  in {
    nixosConfigurations = {
      # GPU-based configurations for default host
      amd = mkHost { hostname = "default"; profile = "amd"; username = "user"; };
      nvidia = mkHost { hostname = "default"; profile = "nvidia"; username = "user"; };
      nvidia-laptop = mkHost { hostname = "default"; profile = "nvidia-laptop"; username = "user"; };
      intel = mkHost { hostname = "default"; profile = "intel"; username = "user"; };
      vm = mkHost { hostname = "default"; profile = "vm"; username = "user"; };

      # Default host configuration
      default = mkHost { hostname = "default"; profile = "nvidia-laptop"; username = "user"; };

      # Host-specific configurations
      # Add new hosts here during installation
      deck = mkHost { hostname = "deck"; profile = "amd"; username = "don"; };
    };

    # Flutter development environment (conditional per host)
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

        # Check if any host has flutter development enabled
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
