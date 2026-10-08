# VSCodium with the user's regular extension set. Gated by
# workstation.mavnezz.dev.enable on the system side; this home-manager
# bit is imported from flake.nix per device.
{ pkgs, ... }: {
  programs.vscodium = {
    enable = true;
    package = pkgs.vscodium;
    profiles = {
      default = {
        # Shared with the official VS Code build (see home/vscode-extensions.nix
        # and modules/mavnezz/dev.nix) so both editors carry the same set.
        extensions = import ./vscode-extensions.nix pkgs;

        userSettings = {
          # The extension's bundled `claude` binary is dynamically linked and
          # does not run on NixOS; point it at the nix-built CLI from
          # pkgs-unstable.claude-code instead.
          "claudeCode.claudeProcessWrapper" = "/run/current-system/sw/bin/claude";

          # Skip the welcome/getting-started page on startup.
          "workbench.startupEditor" = "none";
          "workbench.welcomePage.walkthroughs.openOnInstall" = false;
        };
      };
    };
  };
}
