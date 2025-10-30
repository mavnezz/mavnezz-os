{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "your-username";
  gitEmail = "your-email@example.com";

  # Hyprland Settings
  # ex "monitor=HDMI-A-1, 1920x1080@60,auto,1"
  #
  extraMonitorSettings = ''
  monitor=,preferred,auto,1
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "google-chrome-stable"; # Set Default Browser
  terminal = "kitty"; # Set Default System Terminal
  remoteDesktop = "remmina"; # Remote Desktop Client
  keyboardLayout = "de";
  consoleKeyMap = "de";

  # For Nvidia Prime support - update these with your GPU PCI IDs
  # Use 'lspci | grep VGA' to find your GPU IDs
  intelID = "PCI:0:2:0";  # Intel/AMD integrated GPU
  nvidiaID = "PCI:1:0:0"; # NVIDIA discrete GPU

  # Enable NFS
  enableNFS = true;

  # Enable Printing Support
  printEnable = false;

  # Enable Thunar GUI File Manager
  thunarEnable = true;

  # Enable Controller Support For Gaming
  controllerSupportEnable = false;

  # Enable Flutter Development Environment
  flutterdevEnable = false;

  # Android Development Packages (uncomment in packages.nix to enable)
  #pkgs-unstable.flutter # Flutter SDK
  #androidenv.androidPkgs.platform-tools  # This includes adb
  #androidenv.androidPkgs.emulator        # For Android emulator
  #androidenv.androidPkgs.ndk-bundle

  # Enable Stylix System Theming
  stylixEnable = true;

  # Enable Vicinae Launcher
  vicinaeEnable = false;

  # Enable Syncthing File Synchronization
  syncthingEnable = false;

  # Display Manager Options (choose one - add to host's default.nix)
  # services.greetd.enable = true;           # greetd with tuigreet (default)
  # services.displayManager.ly.enable = true; # ly with matrix animation

  # Set Stylix Image
  stylixImage = ../../wallpapers/marsian.jpeg;
  # Set Waybar
  # Includes alternates such as:
  # Just uncomment the one you want and comment out the others

  #waybarChoice = ../../modules/home/waybar/Jerry-waybars.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-nekodyke.nix;
  waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;

  # Set Animation style
  # Available options are:
  # animations-def.nix  (standard)
  # animations-end4.nix (end-4 project)
  # animations-dynamic.nix (ml4w project)
  # animations-moving.nix (ml4w project)
  # Just change the name after the - and rebuild
  animChoice = ../../modules/home/hyprland/animations-end4.nix;
  #animChoice = ../../modules/home/hyprland/animations-def.nix;
  #animChoice = ../../modules/home/hyprland/animations-dynamix.nix;
  #  Note: Moving changes window resizing it shrinks then pops back
  #animChoice = ../../modules/home/hyprland/animations-moving.nix;
}
