{ config, ... }:

{
  programs.wlogout = {
    enable = true;
    layout = [
      {
        label = "lock";
        action = "sleep 1; hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "sleep 1; hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "sleep 1; systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "sleep 1; systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "sleep 1; systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "sleep 1; systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];
    style = ''
      * {
        background-image: none;
        font-size: 16px;
      }

      window {
        background-color: transparent;
      }

      button {
        color: #${config.lib.stylix.colors.base05};
        background-color: #${config.lib.stylix.colors.base00};
        outline-style: none;
        border: none;
        border-width: 0px;
        background-repeat: no-repeat;
        background-position: center;
        background-size: 25%;
        border-radius: 0px;
        box-shadow: none;
        text-shadow: none;
      }

      button:focus {
        background-color: #${config.lib.stylix.colors.base02};
        background-size: 30%;
      }

      button:hover {
        background-color: #${config.lib.stylix.colors.base03};
        background-size: 40%;
        border-radius: 12px;
        transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
      }

      button:hover#lock {
        border-radius: 12px;
        margin: -10px 0px -10px 10px;
      }

      button:hover#logout {
        border-radius: 12px;
        margin: -10px 0px -10px 0px;
      }

      button:hover#suspend {
        border-radius: 12px;
        margin: -10px 0px -10px 0px;
      }

      button:hover#shutdown {
        border-radius: 12px;
        margin: -10px 0px -10px 0px;
      }

      button:hover#hibernate {
        border-radius: 12px;
        margin: -10px 0px -10px 0px;
      }

      button:hover#reboot {
        border-radius: 12px;
        margin: -10px 10px -10px 0px;
      }

      #lock {
        background-image: image(url("icons/lock.png"));
        border-radius: 12px 0px 0px 12px;
        margin: 10px 0px 10px 10px;
      }

      #logout {
        background-image: image(url("icons/logout.png"));
        border-radius: 0px;
        margin: 10px 0px 10px 0px;
      }

      #suspend {
        background-image: image(url("icons/suspend.png"));
        border-radius: 0px;
        margin: 10px 0px 10px 0px;
      }

      #shutdown {
        background-image: image(url("icons/shutdown.png"));
        border-radius: 0px;
        margin: 10px 0px 10px 0px;
      }

      #hibernate {
        background-image: image(url("icons/hibernate.png"));
        border-radius: 0px;
        margin: 10px 0px 10px 0px;
      }

      #reboot {
        background-image: image(url("icons/reboot.png"));
        border-radius: 0px 12px 12px 0px;
        margin: 10px 10px 10px 0px;
      }
    '';
  };
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };
}
