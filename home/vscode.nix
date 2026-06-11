# VSCodium with the user's regular extension set. Gated by
# workstation.mavnezz.dev.enable on the system side; this home-manager
# bit is imported from flake.nix per device.
{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          jeff-hykin.better-nix-syntax
          mads-hartmann.bash-ide-vscode
          tamasfe.even-better-toml
          zainchen.json
          ms-python.python
          ms-dotnettools.csharp
          bmewburn.vscode-intelephense-client
          ms-azuretools.vscode-docker
          esbenp.prettier-vscode
        ];
      };
    };
  };
}
