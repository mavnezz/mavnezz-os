{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "mavnezz";
  gitEmail = "sirjuls44@github.com";

  # Hyprland Settings
  # Configure your monitors here - this is host-specific
  # ex "monitor=HDMI-A-1, 1920x1080@60,auto,1"
  # You'll need to update this after installation based on your actual monitors
  extraMonitorSettings = ''
    monitor=,preferred,auto,1.5
  '';

  # Waybar Settings
  clock24h = false;

  # Program Options
  browser = "google-chrome-stable"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "kitty"; # Set Default System Terminal
  keyboardLayout = "de";
  consoleKeyMap = "de";

  # For Nvidia Prime support (update these IDs after hardware detection)
  # Run 'lspci | grep VGA' to find your actual GPU IDs
  intelID = "PCI:0:2:0";   # Update this with your actual integrated GPU ID
  nvidiaID = "PCI:1:0:0";  # Update this with your actual NVIDIA GPU ID

  # Enable/Disable Features
  enableNFS = false;
  printEnable = false;
  thunarEnable = true;
  controllerSupportEnable = false;
  flutterdevEnable = false;
  stylixEnable = true;
  vicinaeEnable = false;
  syncthingEnable = false;

  # Styling
  stylixImage = ../../wallpapers/marsian.jpeg;

  # Waybar Choice
  waybarChoice = ../../modules/home/waybar/mavnezz.nix;

  # Animation Choice
  animChoice = ../../modules/home/hyprland/animations-end4.nix;
}
