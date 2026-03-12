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
        "text/html" = "google-chrome.desktop";
        "x-scheme-handler/http" = "google-chrome.desktop";
        "x-scheme-handler/https" = "google-chrome.desktop";
        "x-scheme-handler/about" = "google-chrome.desktop";
        "application/x-extension-htm" = "google-chrome.desktop";
        "application/x-extension-html" = "google-chrome.desktop";
        "application/x-extension-shtml" = "google-chrome.desktop";
        "application/xhtml+xml" = "google-chrome.desktop";
        "application/x-extension-xhtml" = "google-chrome.desktop";
        "application/x-extension-xht" = "google-chrome.desktop";
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
