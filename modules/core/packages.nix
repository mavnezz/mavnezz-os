{pkgs, pkgs-unstable, lib, ...}: {
  programs = {
    neovim = {
      enable = false;
      defaultEditor = false;
    };
    firefox.enable = false; # Firefox is not installed by default
    dconf.enable = true;
    seahorse.enable = true;
    hyprland.enable = true; #create desktop file and depedencies if you switch to GUI login MGR
    hyprlock.enable = true; #resolve pam issue https://gitlab.com/Zaney/zaneyos/-/issues/164
    fuse.userAllowOther = true;
    mtr.enable = true;
    adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "zed"
    "jdk"
    "claude"
  ];

  environment.systemPackages = with pkgs; [
    appimage-run # Needed For AppImage Support
    azure-cli # Azure Command-Line Tools
    bc # Calculator For Scripts
    brightnessctl # For Screen Brightness Control
    cmatrix # Matrix Movie Effect In Terminal
    cowsay # Great Fun Terminal Program
    docker-compose # Allows Controlling Docker From A Single File
    duf # Utility For Viewing Disk Usage In Terminal
    dysk # disk usage util
    eza # Beautiful ls Replacement
    fd # Fast File Finder
    ffmpeg # Terminal Video / Audio Editing
    file-roller # Archive Manager
    nautilus # GNOME File Manager
    gdu # graphical disk usage
    gedit # Simple Graphical Text Editor
    gimp # Great Photo Editor
    glxinfo # Needed for inxi -G GPU info
    gping #graphical ping
    hyprpicker # Color Picker
    inxi # CLI System Information Tool
    jq # JSON Processor For CLI
    killall # For Killing All Instances Of Programs
    lazydocker # Terminal UI for Docker
    libnotify # For Notifications
    lm_sensors # Used For Getting Hardware Temps
    lolcat # Add Colors To Your Terminal Command Output
    lshw # Detailed Hardware Information
    ncdu # Disk Usage Analyzer With Ncurses Interface
    nitch # small fetch util
    # Nix Language Packages
    nixfmt-rfc-style # Nix Formatter
    nixd # Nix Language Server
    nil # Nix Language Server
    onefetch #shows current build info and stats
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    python3 # Python 3 Interpreter
    playerctl # Allows Changing Media Volume Through Scripts
    rclone # Cloud Storage Sync Tool
    ripgrep # Improved Grep
    shellcheck # Shell Script Linter
    socat # Needed For Screenshots
    sox # audio support for FFMPEG
    tree # Directory Structure Viewer
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    wget # Tool For Fetching Files With Links
    yq # YAML Processor For CLI
    nwg-displays # Manage Displays
    nwg-drawer # Application Drawer
    # PHP & Laravel Development
    php83 # PHP 8.3 for Laravel
    php83Packages.composer # PHP Dependency Manager
    nodejs
    #youtube-music
    pkgs-unstable.claude-code # For native development
    pkgs-unstable.nwg-dock-hyprland
    teams-for-linux # Video Meetings
    zoom-us # Video Meetings
    chromium # Browser
    google-chrome # Browser
    gum
    gtk3
    remmina # Remote Desktop Client
    slack # Team Communication
    vlc # Media Player
    anydesk # Remote Desktop
    vivaldi # Browser
  ];
}
