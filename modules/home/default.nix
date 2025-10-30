{inputs, host, ...}: let
  inherit (import ../../hosts/${host}/variables.nix) waybarChoice;
in {
  imports = [
    ./bash.nix
    ./bashrc-personal.nix
    ./bat.nix
    ./btop.nix
    ./cava.nix
    ./emoji.nix
    ./eza.nix
    ./fastfetch
    ./fzf.nix
    ./gh.nix
    ./git.nix
    ./gtk.nix
    ./hyprland
    ./kitty.nix
    ./lazygit.nix
    ./libreoffice.nix
    ./rofi
    ./scripts
    ./starship.nix
    ./stylix.nix
    ./swappy.nix
    ./swaync.nix
    ./tealdeer.nix
    ./tmux.nix
    ./vicinae.nix
    ./virtmanager.nix
    ./vscode.nix
    waybarChoice
    ./wlogout
    ./xdg.nix
    ./yazi
    ./zoxide.nix
    ./zsh
    ./environment.nix
  ];
}
