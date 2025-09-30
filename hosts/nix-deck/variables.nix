{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "theblackdon";
  gitEmail = "theblackdonatello";

  # Hyprland Settings
  # Steam Deck display configuration
  # The Steam Deck has a 1280x800 display at 60Hz
  extraMonitorSettings = ''
    monitor=,preferred,auto,1
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "vivaldi"; # Set Default Browser
  terminal = "kitty"; # Set Default System Terminal
  keyboardLayout = "us";
  consoleKeyMap = "us";

  # Steam Deck uses AMD APU - these IDs are not used
  intelID = "PCI:0:2:0";
  nvidiaID = "PCI:1:0:0";

  # Enable/Disable Features
  enableNFS = false; # Disabled for portable gaming device
  printEnable = false; # Disabled for portable gaming device
  thunarEnable = true;

  # Styling
  stylixImage = ../../wallpapers/Valley.jpg;

  # Waybar Choice
  waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;

  # Animation Choice
  animChoice = ../../modules/home/hyprland/animations-end4.nix;

  # Steam Deck Specific Settings
  steamDeckMode = true; # Flag to enable Steam Deck optimizations
}
