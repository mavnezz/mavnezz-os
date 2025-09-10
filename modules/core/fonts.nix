{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      fira-code-symbols
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      jetbrains-mono
      material-icons
      maple-mono.NF
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      nerd-fonts.meslo-lg
      nerd-fonts.hack
      #symbola   #still 404 error
      terminus_font
    ];
  };
}
