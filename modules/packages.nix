{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.workstation.baseline.packages;
  toolsPackages = with pkgs; [
    # sensei defaults
    yubikey-manager
    wget
    git
    htop
    curl
    tree
    eza
    ghostty
    fastfetch
    starship
    lazyssh
    nixfmt
    blueman
    ffmpeg
    whois
    parted
    usbutils
    smartmontools
    pciutils
    file
    dig
    oh-my-zsh
    autojump
    screen
    speedtest
    unzip
    parallel
    # mavnezz CLI grab-bag
    appimage-run
    bat
    bc
    brightnessctl
    btop
    cava
    cmatrix
    cowsay
    dysk
    duf
    fd
    fzf
    gdu
    gping
    gum
    inxi
    jq
    killall
    lolcat
    lshw
    mesa-demos
    ncdu
    nitch
    onefetch
    rclone
    ripgrep
    shellcheck
    socat
    sox
    tealdeer
    unrar
    yq
    zoxide
  ];

  devPackages = with pkgs; [
    rustup
    cargo
    gcc
    rustlings
    terraform
    distrobox
  ];

  appsPackages = with pkgs; [
    bitwarden-desktop
    yubioath-flutter
    vscodium
    signal-desktop
    (retroarch.withCores (cores: with cores; [ mgba ]))
    vlc
    libreoffice
    gimp
    feishin
    picard
    jellyfin-desktop
    gnome-calculator
    element-desktop
  ];
in
{
  options.workstation.baseline.packages = {
    tools = lib.mkEnableOption "CLI tools and utilities";
    dev = lib.mkEnableOption "Development tools";
    apps = lib.mkEnableOption "Desktop applications";
  };

  config = {
    environment.systemPackages =
      (lib.optionals cfg.tools toolsPackages)
      ++ (lib.optionals cfg.dev devPackages)
      ++ (lib.optionals cfg.apps appsPackages);
  };
}
