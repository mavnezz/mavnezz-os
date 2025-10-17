{pkgs, config}:
pkgs.writeShellScriptBin "rofi-power-menu" ''
  # Options for powermenu (using Nerd Font icons)
  lock="  Lock"
  logout="  Logout"
  shutdown="  Shutdown"
  reboot="  Reboot"
  sleep="  Sleep"

  # Create temporary theme file with Stylix colors
  THEME_FILE="/tmp/rofi-powermenu-theme.rasi"

  cat > "$THEME_FILE" <<EOF
  configuration {
      location: 3;
      font: "JetBrainsMono Nerd Font 12";
      show-icons: false;
      drun-display-format: "{name}";
  }

  * {
    border: 0;
    margin: 0;
    padding: 0;
    spacing: 0;
    background: #${config.stylix.base16Scheme.base00};
    background-alt: #${config.stylix.base16Scheme.base01};
    line: #${config.stylix.base16Scheme.base03};
    foreground: #${config.stylix.base16Scheme.base05};
    foreground-alt: #${config.stylix.base16Scheme.base05};
    comment: #${config.stylix.base16Scheme.base04};
    selected: #${config.stylix.base16Scheme.base04};
    background-color: @background;
    text-color: @foreground;
  }

  window {
      background-color: @background;
      border: 2px;
      border-color: @line;
      border-radius: 10px;
      width: 180px;
      height: 280px;
      x-offset: -10;
      y-offset: 35;
  }

  listview {
      background-color: @background;
      columns: 1;
      lines: 5;
      spacing: 10px;
      layout: vertical;
  }

  mainbox {
      background-color: @background;
      children: [ listview ];
      padding: 15px;
  }

  element {
      background-color: @background;
      text-color: @line;
      orientation: horizontal;
  }

  element-text {
      background-color: inherit;
      text-color: inherit;
      font: "JetBrainsMono Nerd Font 12";
      expand: true;
      horizontal-align: 0;
      vertical-align: 0.5;
      margin: 0px;
      padding: 8px 12px;
  }

  element selected {
      background-color: @line;
      text-color: @foreground;
      border: 0px;
      border-radius: 5px;
  }

  element selected.active {
      background-color: @line;
      text-color: @foreground;
  }
  EOF

  # Get answer from user via rofi
  selected_option=$(echo -e "$lock\n$logout\n$sleep\n$reboot\n$shutdown" | \
    ${pkgs.rofi-wayland}/bin/rofi -dmenu \
      -i \
      -p "Power" \
      -theme "$THEME_FILE")

  # Do something based on selected option (case insensitive matching)
  case "$selected_option" in
      *"Lock"*)
          ${pkgs.hyprlock}/bin/hyprlock
          ;;
      *"Logout"*)
          ${pkgs.hyprland}/bin/hyprctl dispatch exit
          ;;
      *"Shutdown"*)
          systemctl poweroff
          ;;
      *"Reboot"*)
          systemctl reboot
          ;;
      *"Sleep"*)
          systemctl suspend
          ;;
  esac

  # Clean up temp theme file
  rm -f "$THEME_FILE"
''
