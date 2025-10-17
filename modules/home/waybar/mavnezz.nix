{
  pkgs,
  config,
  lib,
  ...
}: let
  terminal = "kitty";
  # Use Stylix colors dynamically generated from wallpaper
  base00 = config.stylix.base16Scheme.base00;
  base01 = config.stylix.base16Scheme.base01;
  base03 = config.stylix.base16Scheme.base03;
  base05 = config.stylix.base16Scheme.base05;
  base06 = config.stylix.base16Scheme.base06;
  base07 = config.stylix.base16Scheme.base07;
  base08 = config.stylix.base16Scheme.base08;
  base09 = config.stylix.base16Scheme.base09;
  base0A = config.stylix.base16Scheme.base0A;
  base0B = config.stylix.base16Scheme.base0B;
  base0C = config.stylix.base16Scheme.base0C;
  base0D = config.stylix.base16Scheme.base0D;
  base0E = config.stylix.base16Scheme.base0E;
  base0F = config.stylix.base16Scheme.base0F;
in
  with lib; {
    # Configure & Theme Waybar
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [
        {
          layer = "top";
          position = "top";

          modules-center = ["network" "pulseaudio" "cpu" "hyprland/workspaces" "memory" "disk" "clock"]; # Eterna: [ "hyprland/window" ]
          modules-left = ["custom/startmenu" "hyprland/window"]; # Eternal:  [ "hyprland/workspaces" "cpu" "memory" "network" ]
          modules-right = ["tray" "idle_inhibitor" "custom/notification" "battery" "custom/exit"]; # Eternal: [ "idle_inhibitor" "pulseaudio" "clock"  "custom/notification" "tray" ]

          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format = '' {:%H:%M}'';
            /*
            ''{: %I:%M %p}'';
            */
            tooltip = true;
            tooltip-format = "<big>{:%A, %d.%B %Y }</big><tt><small>{calendar}</small></tt>";
          };
          "hyprland/window" = {
            max-length = 60;
            separate-outputs = false;
          };
          "memory" = {
            interval = 5;
            format = " {}%";
            tooltip = true;
            on-click = "${terminal} -e btop";
          };
          "cpu" = {
            interval = 5;
            format = " {usage:2}%";
            tooltip = true;
            on-click = "${terminal} -e btop";
          };
          "disk" = {
            format = " {free}";
            tooltip = true;
            # Not working with zaneyos window open then closes
            #on-click = "${terminal} -e sh -c df -h ; read";
          };
          "network" = {
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            format-ethernet = " {bandwidthDownBits}";
            format-wifi = " {bandwidthDownBits}";
            format-disconnected = "󰤮";
            tooltip = false;
            on-click = "${terminal} -e btop";
          };
          "tray" = {
            spacing = 12;
          };
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };
          "custom/exit" = {
            tooltip = false;
            format = "⏻";
            on-click = "rofi-power-menu";
          };
          "custom/startmenu" = {
            tooltip = false;
            format = " ";
            # exec = "rofi -show drun";
            on-click = "rofi -show drun";
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = " ";
              deactivated = " ";
            };
            tooltip = "true";
          };
          "custom/notification" = {
            tooltip = false;
            format = "{icon} {}";
            format-icons = {
              notification = "<span foreground='#'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='#'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='#'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='#'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "swaync-client -t";
            escape = true;
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            on-click = "";
            tooltip = false;
          };
        }
      ];
      style = concatStrings [
        ''
          * {
            font-size: 13px;
            font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
            font-weight: bold;
          }
          window#waybar {
            background-color: #${base00};
            border-bottom: 2px solid #${base03};
            border-radius: 0px;
            color: #${base05};
          }
          #workspaces {
            background: transparent;
            margin: 5px;
            padding: 0px 1px;
            border-radius: 15px;
            border: 0px;
            font-style: normal;
            color: #${base05};
          }
          #workspaces button {
            padding: 0px 5px;
            margin: 4px 3px;
            border-radius: 15px;
            border: 0px;
            color: #${base05};
            background: #${base03};
            opacity: 0.5;
            transition: all 0.3s ease-in-out;
          }
          #workspaces button.active {
            padding: 0px 5px;
            margin: 4px 3px;
            border-radius: 15px;
            border: 0px;
            color: #${base05};
            background: #${base03};
            opacity: 1.0;
            min-width: 40px;
            transition: all 0.3s ease-in-out;
          }
          #workspaces button:hover {
            border-radius: 15px;
            color: #${base05};
            background: #${base03};
            opacity: 0.8;
          }
          tooltip {
            background: #${base00};
            border: 1px solid #${base03};
            border-radius: 10px;
          }
          tooltip label {
            color: #${base07};
          }
          #window {
            margin: 5px;
            padding: 2px 20px;
            color: #${base05};
            background: transparent;
            border-radius: 0px;
          }
          #memory {
            color: #${base05};
            background: transparent;
            margin: 5px;
            padding: 2px 20px;
            border-radius: 0px;
          }
          #clock {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #idle_inhibitor {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #cpu {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #disk {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #battery {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #network {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #tray {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #pulseaudio {
            color: #${base05};
            background: transparent;
            margin: 4px;
            padding: 2px 20px;
            border-radius: 0px;
          }
          #custom-notification {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #custom-startmenu {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px 5px 5px 0px;
            padding: 2px 20px;
          }
          #idle_inhibitor {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px;
            padding: 2px 20px;
          }
          #custom-exit {
            color: #${base05};
            background: transparent;
            border-radius: 0px;
            margin: 5px 0px 5px 5px;
            padding: 2px 20px;
          }
        ''
      ];
    };
  }
