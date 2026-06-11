{ pkgs }:

pkgs.writeShellScriptBin "mouse-jiggler" ''
  echo "Mouse Jiggler gestartet (alle 60s). Beende mit Ctrl+C."
  while true; do
    ${pkgs.ydotool}/bin/ydotool mousemove -x 1 -y 0
    sleep 0.2
    ${pkgs.ydotool}/bin/ydotool mousemove -x -1 -y 0
    sleep 60
  done
''
