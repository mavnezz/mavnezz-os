{ pkgs, ... }: {
  home.packages = [
    (import ./emopicker9000.nix { inherit pkgs; })
    (import ./task-waybar.nix { inherit pkgs; })
    (import ./squirtle.nix { inherit pkgs; })
    (import ./nvidia-offload.nix { inherit pkgs; })
    (import ./wallsetter.nix { inherit pkgs; })
    (import ./web-search.nix { inherit pkgs; })
    (import ./hm-find.nix { inherit pkgs; })
    (import ./mouse-jiggler.nix { inherit pkgs; })
    (import ./dcli.nix {
      inherit pkgs;
      backupFiles = [
        ".config/mimeapps.list.backup"
        ".config/libreoffice/4/user/registrymodifications.xcu.backup"
      ];
    })
  ];
}
