{ pkgs }:

pkgs.writeShellScriptBin "fullscreenshot" ''
  grim - | swappy -f -
''
