{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;
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
