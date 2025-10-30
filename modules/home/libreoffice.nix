{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-fresh
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
  ];

  # LibreOffice Konfiguration
  home.file.".config/libreoffice/4/user/registrymodifications.xcu".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <oor:items xmlns:oor="http://openoffice.org/2001/registry" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <item oor:path="/org.openoffice.Office.Linguistic/General"><prop oor:name="UILocale" oor:op="fuse"><value>de-DE</value></prop></item>
      <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Writer"><prop oor:name="Mode" oor:op="fuse"><value>notebookbar_groups.ui</value></prop></item>
      <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Calc"><prop oor:name="Mode" oor:op="fuse"><value>notebookbar_groups.ui</value></prop></item>
      <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Impress"><prop oor:name="Mode" oor:op="fuse"><value>notebookbar_groups.ui</value></prop></item>
      <item oor:path="/org.openoffice.Office.UI.ToolbarMode/Applications/Draw"><prop oor:name="Mode" oor:op="fuse"><value>notebookbar_groups.ui</value></prop></item>
    </oor:items>
  '';

  # Umgebungsvariablen für deutsche Sprache
  home.sessionVariables = {
    LANG = "de_DE.UTF-8";
  };
}
