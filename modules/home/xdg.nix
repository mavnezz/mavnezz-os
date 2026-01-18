{pkgs, ...}: {
  xdg = {
    enable = true;
    mime.enable = true;
    desktopEntries = {
      AnyDesk = {
        name = "AnyDesk";
        comment = "Remote Desktop";
        exec = "env GDK_BACKEND=x11 anydesk %u";
        icon = "anydesk";
        terminal = false;
        type = "Application";
        categories = ["Network" "RemoteAccess"];
        noDisplay = false;
      };
      snapmaker-orca = {
        name = "Snapmaker OrcaSlicer";
        comment = "3D Slicer for Snapmaker";
        exec = "snapmaker-orca %F";
        icon = "orca-slicer";
        terminal = false;
        type = "Application";
        categories = ["Graphics" "3DGraphics" "Engineering"];
        mimeType = ["model/stl" "model/3mf" "application/vnd.ms-3mfdocument"];
      };
      bambu-studio = {
        name = "Bambu Studio";
        comment = "3D Slicer for Bambu Lab printers";
        exec = "bambu-studio %F";
        icon = "bambu-studio";
        terminal = false;
        type = "Application";
        categories = ["Graphics" "3DGraphics" "Engineering"];
        mimeType = ["model/stl" "model/3mf" "application/vnd.ms-3mfdocument"];
      };
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "vivaldi-stable.desktop";
        "x-scheme-handler/http" = "vivaldi-stable.desktop";
        "x-scheme-handler/https" = "vivaldi-stable.desktop";
        "x-scheme-handler/about" = "vivaldi-stable.desktop";
        "application/x-extension-htm" = "vivaldi-stable.desktop";
        "application/x-extension-html" = "vivaldi-stable.desktop";
        "application/x-extension-shtml" = "vivaldi-stable.desktop";
        "application/xhtml+xml" = "vivaldi-stable.desktop";
        "application/x-extension-xhtml" = "vivaldi-stable.desktop";
        "application/x-extension-xht" = "vivaldi-stable.desktop";
      };
    };
    portal = {
      enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-wlr
      ];
      configPackages = [ pkgs.hyprland ];
    };
  };
}
