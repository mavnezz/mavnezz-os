{pkgs, ...}: {
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;
    profiles = {
      default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          jeff-hykin.better-nix-syntax
          mads-hartmann.bash-ide-vscode
          tamasfe.even-better-toml
          zainchen.json
        ];
      };
    };
  };
}
